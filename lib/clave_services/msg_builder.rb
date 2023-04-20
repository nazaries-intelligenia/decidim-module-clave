# frozen_string_literal: true

require_relative "document_signer"

module ClaveServices
  NOKOGIRI_OPTIONS = Nokogiri::XML::ParseOptions::STRICT |
                     Nokogiri::XML::ParseOptions::NONET

  class MsgBuilder
    def initialize
      @uuid = OneLogin::RubySaml::Utils.uuid
    end

    # AuthNRequest ID
    attr_reader :uuid

    def build(request, settings)
      @request= request
      xml_str= filled_template.squish
      xml_str= xml_str.gsub("> <", "><")
      request_doc= XMLSecurity::Document.new(xml_str)
      request_doc.uuid = uuid
      ::ClaveServices::DocumentSigner.new(settings).sign_document(request_doc)
      xml_str.gsub("<saml2p:Extensions>", "#{request_doc.root.children.second}<saml2p:Extensions>")
    end

    def filled_template
      template= pristine_template
      template= template.gsub(":{id}", uuid)
      time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
      template= template.gsub(/IssueInstant="\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\dZ"/, "IssueInstant=\"#{time}\"")
      template= template.gsub(":{issuer}", uuid)
      template= template.gsub(":{provider-name}", Rails.application.secrets.omniauth.dig(:clave, :sp_entity_id))
      callback_url= "#{@request.base_url}/users/auth/clave/callback"
      template.gsub(":{callback_url}", callback_url)
    end

    def pristine_template
      @pristine_template||= <<~EOTEMPLATE.squish
        <saml2p:AuthnRequest xmlns:saml2p="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" xmlns:eidas="http://eidas.europa.eu/saml-extensions" xmlns:eidas-natural="http://eidas.europa.eu/attributes/naturalperson" ID=":{id}" Version="2.0" IssueInstant="2022-07-09T08:07:46Z" Destination="#{Rails.application.secrets.omniauth.dig(:clave, :idp_sso_service_url)}" ForceAuthn="false" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" AssertionConsumerServiceURL=":{callback_url}" ProviderName=":{provider-name}">
          <saml2:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">:{issuer}</saml2:Issuer>
          <saml2p:Extensions>
            <eidas:SPType>public</eidas:SPType>
            <eidas:RequestedAttributes/>
          </saml2p:Extensions>
          <saml2p:NameIDPolicy Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient" AllowCreate="true"/>
          <saml2p:RequestedAuthnContext Comparison="minimum">
            <saml2:AuthnContextClassRef xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">http://eidas.europa.eu/LoA/low</saml2:AuthnContextClassRef>
          </saml2p:RequestedAuthnContext>
        </saml2p:AuthnRequest>
      EOTEMPLATE
    end
  end
end
