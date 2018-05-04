module MDQT
  class Client

    class MetadataResponse

      require 'digest'

      def initialize(identifier, http_response)

        @identifier    = identifier
        @code          = http_response.status
        @data          = http_response.body
        @type          = http_response.headers['Content-Type']
        @expires       = http_response.headers['Expires']
        @etag          = http_response.headers['ETag']
        @last_modified = http_response.headers['Last-Modified']
        @ok            = http_response.success?
      end

      def identifier
        @identifier
      end

      def code
        @status
      end

      def data
        @data
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

    end

  end

end