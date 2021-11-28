module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Entities < Base

      def run

        options.validate = true

        advise_on_xml_signing_support
        halt!("Cannot check a metadata file without XML support: please install additional gems") unless MDQT::Client.verification_available?

        client = MDQT::Client.new(
            options.service,
            verbose: options.verbose,
            explain: options.explain ? true : false,
            )

        args.each do |filename|

          filename = File.absolute_path(filename)
          file = client.open_metadata(filename)

          halt!("Cannot access file #{filename}") unless file.readable?

          halt!("XML validation failed for #{filename}:\n#{file.validation_error}") unless file.valid?

          doc = Nokogiri::XML.parse(file.data).remove_namespaces!
          doc.xpath("//EntityDescriptor/@entityID").map(&:text).each do |id|
            id = options.sha1 ? [id, MDQT::Client::IdentifierUtils.transform_uri(id)].join(" ") : id
            say(id)
          end

        end

      end

    end

    private

  end

end


