# frozen_string_literal: true

require_relative "clave/version"
require_relative "clave/engine"

module Decidim
  module Clave
    class Error < StandardError; end

    class ClaveAutosubmitForm
      def call(env)
        settings= OneLogin::RubySaml::Settings.new(env["omniauth.strategy"].options)
        request = Rack::Request.new(env)
        request_str= ::ClaveServices::MsgBuilder.new.build(request, settings)
        noko = Nokogiri::XML(request_str) do |config|
          config.options = ClaveServices::NOKOGIRI_OPTIONS
          config.noblanks
          config.strict.noblanks
        end
        request_str= noko.to_xml(indent_text: "", indent: 0).gsub("\n", "").gsub("<?xml version=\"1.0\"?>", "")

        base64_request = Base64.strict_encode64(request_str)
        base64_request= CGI.escapeHTML(base64_request)
        rq_value= base64_request

        html = <<~EOHTML
          <!DOCTYPE html>
          <html lang="en">
          <head>
          <meta http-equiv="content-type" content="text/html; charset=utf-8" />
          <title>POST data</title>
          </head>
          <body onload="document.forms[0].submit()">
          <noscript>
          <p><strong>Note:</strong> Since your browser does not support JavaScript, you must press the button below once to proceed.</p>
          </noscript>
          <form method="post" action="#{ENV["CLAVE_IDP_SSO_SERVICE_URL"]}">
          <input type="hidden" name="SAMLRequest" value="#{rq_value}" />
          <noscript><input type="submit" value="Submit" /></noscript>
          </form>
          </body>
          </html>
        EOHTML
        [200, {}, [html]]
      end
    end

    def self.setup_clave_env(env)
      request = Rack::Request.new(env)
      organization = Decidim::Organization.find_by(host: request.host)
      org_config = organization.enabled_omniauth_providers[:clave]
      conf= env["omniauth.strategy"].options
      conf.merge!(Decidim::Clave::STRATEGY_STATIC_CONFIG)
      conf[:sp_entity_id] = org_config[:sp_entity_id].presence || Rails.application.secrets.omniauth.dig(:clave, :sp_entity_id)
      conf[:idp_sso_service_url] = org_config[:site_url].presence || Rails.application.secrets.omniauth.dig(:clave, :idp_sso_service_url)
      conf[:idp_cert_fingerprint] = org_config[:idp_cert_fingerprint].presence || Rails.application.secrets.omniauth.dig(:clave, :idp_cert_fingerprint)
      conf[:certificate] = org_config[:sp_certificate].presence || Rails.application.secrets.omniauth.dig(:clave, :sp_certificate)
      conf[:private_key] = org_config[:sp_private_key].presence || Rails.application.secrets.omniauth.dig(:clave, :sp_private_key)
      # response config
      conf[:idp_cert] = org_config[:idp_certificate].presence || Rails.application.secrets.omniauth.dig(:clave, :idp_certificate)
    end

    STRATEGY_STATIC_CONFIG= {
      # response config
      form: ClaveAutosubmitForm.new,
      double_quote_xml_attribute_values: true,
      skip_conditions: true,
      skip_audience: true,
      attribute_statements: {
        name: ["http://eidas.europa.eu/attributes/naturalperson/CurrentGivenName", "name"],
        email: %w(email mail),
        first_name: ["http://eidas.europa.eu/attributes/naturalperson/CurrentGivenName", "first_name", "firstname", "firstName"],
        first_surname: ["http://es.minhafp.clave/FirstSurname", "first_name", "firstname", "firstName"],
        last_name: ["http://eidas.europa.eu/attributes/naturalperson/CurrentFamilyName", "last_name", "lastname", "lastName"]
      },
    }
  end
end
