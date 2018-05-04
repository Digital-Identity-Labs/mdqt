module MDQT
  class Client

    class MetadataResponse

      require 'digest'

      def initialize(identifier, service, http_response)

        @identifier = URI.decode(identifier)
        @service = service
        @code = http_response.status || 500
        @data = http_response.body || ""
        @type = http_response.headers['Content-Type']
        @expires = http_response.headers['Expires']
        @etag = http_response.headers['ETag']
        @last_modified = http_response.headers['Last-Modified']
        @ok = http_response.success?
      end

      def identifier
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
        @data.include? "<Signature" # This is... not great
      end

      def filename
        "#{Digest::SHA1.hexdigest(@identifier)}.xml"
      end

      def error_message
        case code
        when 404
          "[404] Entity metadata for '#{identifier}' could not be found at #{service}"
        when 403
          identifier.empty? ? "[403] The MDQ service at #{service} does not support aggregate downloads" :
              "[403] You do not have access rights to '#{identifier}' at #{service}"
        else
          "[#{code}] Sorry - an unknown error has occured requesting '#{identifier}' from #{service}.\nPlease report this bug!"
        end
      end

    end

  end

end