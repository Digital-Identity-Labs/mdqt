module MDQT
  class Client

    class MetadataFile

      require 'digest'

      def initialize(filename, options = {})
        @filename = filename
        @identifier = nil
        @data = nil
        @expires = nil
        @etag = nil
        @last_modified = nil
        @explanation = {}
      end

      def filename
        @filename
      end

      def identifier
        @identifier
      end

      def data
        @data ||= File.read(filename)
      end

      def readable?
        File.readable?(filename)
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

      def canonical_filename
        if identifier.empty?
          @filename = "aggregate-#{Digest::SHA1.hexdigest(@service)}.xml"
        else
          @filename ||= identifier.start_with?("{sha1}") ?
                            "#{@identifier.gsub("{sha1}","")}.xml" :
                            "#{Digest::SHA1.hexdigest(@identifier)}.xml"
        end
      end

      private

    end

  end

end