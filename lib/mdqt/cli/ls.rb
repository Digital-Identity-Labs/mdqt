module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Ls < Base

      def run

        options.validate = true

        advise_on_xml_signing_support
        halt!("Cannot check a metadata file without XML support: please install additional gems") unless MDQT::Client.verification_available?

        client = MDQT::Client.new(
          options.service,
          verbose: options.verbose,
          explain: options.explain ? true : false,
        )

        results = []

        args.each do |filename|

          file = client.open_metadata(filename)

          halt!("Cannot access file #{filename}") unless file.readable?

          #halt!("File #{filename} is a metadata aggregate, cannot create entityID hashed link!") if file.aggregate?
          next if file.aggregate?
          halt!("XML validation failed for #{filename}:\n#{file.validation_error}") unless file.valid?

          halt!("Cannot find entityID for #{filename}") unless file.entity_id

          results << {id: file.entity_id, type: file.type, filename: file.basename}

        end

        results.sort_by { | r | [r[:id], r[:type]] }.each {|r| puts "#{r[:id]}, #{r[:type]}, #{r[:filename]}" }

      end

    end

    private

  end

end


