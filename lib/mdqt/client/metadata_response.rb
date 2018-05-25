module MDQT
  class Client

    class MetadataResponse

      require 'digest'

      def initialize(identifier, service, http_response, options = {})

        @requested_identitier = identifier
        @identifier = URI.decode(identifier)
        @service = service
        @code = http_response.status || 500
        @data = http_response.body || ""
        @type = http_response.headers['Content-Type']
        @expires = http_response.headers['Expires']
        @etag = http_response.headers['ETag']
        @last_modified = http_response.headers['Last-Modified']
        @ok = http_response.success?
        @explanation = {}

        if options[:explain]
          @explanation[:url] = http_response.env.url.to_s
          @explanation[:method] = http_response.env.method.to_s.upcase
          @explanation[:status] = http_response.status
          @explanation[:response_headers] = http_response.headers
          @explanation[:request_headers] = http_response.env.request_headers
        end

      end

      def identifier
        @identifier
      end

      def requested_identifier
        @identifier
      end

      def service
        @service
      end

      def code
        @code
      end

      def data
        @data || ""
      end

      def type
        @type
      end

      def expires
        @expires
      end

      def etag
        @etag
      end

      def last_modified
        @last_modified
      end

      def ok?
        @ok
      end

      def signed?
        @data.include? "Signature" # This is... not great
      end

      def verified_signature?(certs = [], _ = {})
        return true unless ok?  # CHECK ?
        validator = MetadataValidator.new(certs: [certs].flatten)
        validator.verified_signature?(self)
      end

      def valid?
        validator = MetadataValidator.new
        validator.valid?(self)
      end

      def validation_error
        validator = MetadataValidator.new
        validator.validation_error(self)
      end

      def filename
        if identifier.empty?
          @filename = "aggregate-#{Digest::SHA1.hexdigest(@service)}.xml"
        else
          @filename ||= identifier.start_with?("{sha1}") ?
                            "#{@identifier.gsub("{sha1}","")}.xml" :
                            "#{Digest::SHA1.hexdigest(@identifier)}.xml"
        end
      end

      def message
        case code
        when 200
          identifier.empty? ? "[200] OK! Data for aggregate has been downloaded from #{service}" :
              "[200] OK! Data for '#{identifier}' has been downloaded from #{service}"
        when 304
          "[304] OK! Data for '#{identifier}' is already available in a local cache"
        when 400
          "[400] The identifier '#{identifier}' ('#{requested_identifier}') is malformed or service URL #{service} is incorrect"
        when 401
          "[401] Credentials are incorrect or missing for '#{identifier}'"
        when 403
          identifier.empty? ? "[403] The MDQ service at #{service} does not support aggregate downloads" :
              "[403] You do not have access rights to '#{identifier}' at #{service}"
        when 404
          identifier.empty? ? "[404] The MDQ service at #{service} is not responding with aggregated metadata or the correct status" :
              "[404] Entity metadata for '#{identifier}' was not found at #{service}"
        when 405
          "[405] The service at #{service} believes the wrong HTTP method was used. We should have used HTTP GET..."
        when 406
          "[406] The requested content type is not available at #{service}"
        when 500
          "[500] An error has occurred at #{service}"
        when 505
          "[505] The service at #{service} claims our request was using pre-1999 web protocols, not HTTP 1.1 or later"
        else
          "[#{code}] Sorry - an unknown error has occurred requesting '#{identifier}' from #{service}.\nPlease report this bug!"
        end
      end

      def explanation
        @explanation
      end

      private


    end

  end

end