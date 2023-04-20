# frozen_string_literal: true

module ClaveServices
  class DocumentSigner
    C14N = "http://www.w3.org/2001/10/xml-exc-c14n#"
    CANON_ALGORITHM = Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
    DSIG = "http://www.w3.org/2000/09/xmldsig#"

    ENVELOPED_SIG = "http://www.w3.org/2000/09/xmldsig#enveloped-signature"
    SIGN_METHOD = "http://www.w3.org/2001/04/xmldsig-more#rsa-sha512"
    DIGEST_METHOD = "http://www.w3.org/2001/04/xmlenc#sha512"

    def initialize(settings)
      @private_key = settings.get_sp_key
      @certificate = settings.get_sp_cert
      @certificate = OpenSSL::X509::Certificate.new(@certificate) if @certificate.is_a?(String)
    end

    def algorithm(element)
      algorithm = element
      algorithm = element.attribute("Algorithm").value if algorithm.is_a?(REXML::Element)

      algorithm = algorithm && algorithm =~ /(rsa-)?sha(.*?)$/i && Regexp.last_match(2).to_i

      case algorithm
      when 256 then OpenSSL::Digest::SHA256
      when 384 then OpenSSL::Digest::SHA384
      when 512 then OpenSSL::Digest::SHA512
      else
        OpenSSL::Digest::SHA1
      end
    end

    # Embed signature
    #
    # <Signature>
    # <SignedInfo>
    # <CanonicalizationMethod />
    # <SignatureMethod />
    # <Reference>
    # <Transforms>
    # <Transform>
    # <Transform>
    # <DigestMethod>
    # <DigestValue>
    # </Reference>
    # </SignedInfo>
    # <SignatureValue />
    # <KeyInfo />
    # </Signature>
    def sign_document(document)
      noko = Nokogiri::XML(document.to_s) do |config|
        config.options = ::ClaveServices::NOKOGIRI_OPTIONS
      end

      signature_element = REXML::Element.new("ds:Signature").add_namespace("ds", DSIG)
      signed_info_element = signature_element.add_element("ds:SignedInfo")
      signed_info_element.add_element("ds:CanonicalizationMethod", { "Algorithm" => C14N })
      signed_info_element.add_element("ds:SignatureMethod", { "Algorithm"=>SIGN_METHOD })

      # Add Reference
      reference_element = signed_info_element.add_element("ds:Reference", { "URI" => "##{document.uuid}" })

      # Add Transforms
      transforms_element = reference_element.add_element("ds:Transforms")
      transforms_element.add_element("ds:Transform", { "Algorithm" => ENVELOPED_SIG })
      transforms_element.add_element("ds:Transform", { "Algorithm" => C14N })

      digest_method_element = reference_element.add_element("ds:DigestMethod", { "Algorithm" => DIGEST_METHOD })
      canon_doc = noko.canonicalize(CANON_ALGORITHM)
      reference_element.add_element("ds:DigestValue").text = compute_digest(canon_doc, algorithm(digest_method_element))

      # add SignatureValue
      noko_sig_element = Nokogiri::XML(signature_element.to_s) do |config|
        config.options = ::ClaveServices::NOKOGIRI_OPTIONS
      end

      noko_signed_info_element = noko_sig_element.at_xpath("//ds:Signature/ds:SignedInfo", "ds" => DSIG)
      canon_string = noko_signed_info_element.canonicalize(CANON_ALGORITHM)

      signature = compute_signature(algorithm(SIGN_METHOD).new, canon_string)
      signature_element.add_element("ds:SignatureValue").text = signature.gsub("\n", "")

      # add KeyInfo
      key_info_element = signature_element.add_element("ds:KeyInfo")
      x509_element = key_info_element.add_element("ds:X509Data")
      x509_cert_element = x509_element.add_element("ds:X509Certificate")
      x509_cert_element.text = Base64.strict_encode64(@certificate.to_der).strip

      # add the signature
      issuer_element = document.elements["//saml2:Issuer"]
      if issuer_element
        document.root.insert_after issuer_element, signature_element
      else
        sp_sso_descriptor = document.elements["/md:EntityDescriptor"]
        if sp_sso_descriptor
          document.root.insert_before sp_sso_descriptor, signature_element
        else
          document.root.add_element(signature_element)
        end
      end
    end

    protected

    def compute_signature(signature_algorithm, document)
      Base64.encode64(@private_key.sign(signature_algorithm, document)).strip
    end

    def compute_digest(document, digest_algorithm)
      digest = digest_algorithm.digest(document)
      Base64.strict_encode64(digest).strip
    end
  end
end
