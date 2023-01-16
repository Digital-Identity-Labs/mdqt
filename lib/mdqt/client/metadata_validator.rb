module MDQT
  class Client

    class MetadataValidator

      def initialize(options = {})
        @certs = options[:certs] || []
      end

      def verified_signature?(response)
        begin
          signed_document = Xmldsig::SignedDocument.new(response.data)
          return true if certificates.any? {|c| signed_document.validate(c)}
          false
        rescue => oops
          STDERR.puts oops
          false
        end
      end

      def valid?(response)
        begin
          errors = schema.validate(Nokogiri::XML(response.data)  { |config| config.strict } )
          return false unless errors.length.zero?
          true
        rescue => oops
          false
        end
      end

      def validation_error(response)
        begin
          errors = schema.validate(Nokogiri::XML(response.data)  { |config| config.strict } )
          return nil if errors.empty?
          errors.join("\n")
        rescue => oops
          return "Invalid XML! #{oops.to_s}"
        end
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
        begin
          return cert_object if cert_object.kind_of?(OpenSSL::X509::Certificate)
          return OpenSSL::X509::Certificate.new(cert_object) if cert_object.kind_of?(String) && cert_object.include?("-----BEGIN CERTIFICATE-----")
          OpenSSL::X509::Certificate.new(File.open(cert_object))
        rescue => oops
          raise
        end
      end

      def schema
        @schema ||= Nokogiri::XML::Schema(schema_data_fh)
      end

      def schema_data_fh
        File.open(File.join(__dir__, '../schema/mdqt_check_schema.xsd'))
      end

    end

  end

end