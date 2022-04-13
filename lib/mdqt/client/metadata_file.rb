module MDQT
  class Client

    class MetadataFile

      require 'digest'

      def initialize(filename, options = {})
        @filename = File.absolute_path(filename)
        @data = nil
        @expires = nil
        @etag = nil
        @last_modified = nil
        @explanation = {}
      end

      def filename
        @filename
      end

      def basename
        File.basename(filename)
      end

      def identifier
        entity_id
      end

      def entity_id
        raise "Incorrect metadata file type - aggregate" if aggregate?
        @entity_id ||= extract_entity_id
      end

      def entity_ids
        @entity_ids ||= extract_entity_ids
      end

      def data
        @data ||= File.read(filename)
      end

      def readable?
        File.readable?(filename)
      end

      def turd?
        return true if basename.end_with?("~")
        return true if basename.end_with?(".bak")
        false
      end

      def type
        @type ||= calculate_type
      end

      def aggregate?
        type == :aggregate
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
                          "#{@identifier.gsub("{sha1}", "")}.xml" :
                          "#{Digest::SHA1.hexdigest(@identifier)}.xml"
        end
      end

      def linkname
        if aggregate?
          raise "Not supported for aggregates"
        else
          "#{Digest::SHA1.hexdigest(entity_id)}.xml"
        end
      end

      def symlink?
        File.symlink?(filename)
      end

      private

      def calculate_type
        return :aggregate if data.include?("<EntitiesDescriptor")
        if data.include?("EntityDescriptor")
          return :alias if symlink?
          return :entity
        end
        :unknown
      end

      def xml_doc
        Nokogiri::XML.parse(data).remove_namespaces!
      end

      def extract_entity_id
        xml_doc.xpath("/EntityDescriptor/@entityID").text
      end

      def extract_entity_ids
        xml_doc.xpath("//EntityDescriptor/@entityID").map(&:text)
      end

    end

  end

end