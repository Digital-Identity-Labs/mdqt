module MDQT
  class Client

    class MetadataValidator

      require 'xmldsig'

      def initialize(options = {})
        @certs = options[:certs] || []
      end

      def verified_signature?(response)
        signed_document = Xmldsig::SignedDocument.new(response.data)
        return true if certificates.any? {|c| signed_document.validate(c)}
        false
      rescue => oops
        STDERR.puts oops
        false
      end

      def certificates?
        certificates.present?
      end

      def certificates
        @certificates ||= normalize_certs(certs)
      end

      private

      def certs
        @certs
      end

      def normalize_certs(certs)
        certs.collect {|c| normalize_cert(c)}
      end

      def normalize_cert(cert_object)
        return cert_object if cert_object.kind_of?(OpenSSL::X509::Certificate)
        return OpenSSL::X509::Certificate.new(cert_object) if cert_object.kind_of?(String) && cert_object.include?("-----BEGIN CERTIFICATE-----")
        OpenSSL::X509::Certificate.new(File.open(cert_object))
      rescue => oops
        raise "Unable to process certificate: #{cert_object}"
      end

    end

  end

end