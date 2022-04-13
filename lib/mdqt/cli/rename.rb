module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Rename < Base

      def run

        options.validate = true

        advise_on_xml_signing_support
        halt!("Cannot check a metadata file without XML support: please install additional gems") unless MDQT::Client.verification_available?

        client = MDQT::Client.new(
          options.service,
          verbose: options.verbose,
          explain: options.explain ? true : false,
        )

        halt!("Please specify a file to rename!") if args.empty?

        args.each do |filename|

          next if File.symlink?(filename)

          file = client.open_metadata(filename)

          halt!("Cannot access file #{filename}") unless file.readable?
          halt!("File #{filename} is a metadata aggregate, cannot rename to hashed entityID!") if file.aggregate?
          halt!("XML validation failed for #{filename}:\n#{file.validation_error}") unless file.valid?

          halt!("Cannot find entityID for #{filename}") unless file.entity_id

          newname = file.linkname # Using the same name as the link, not super-obvious
          next if filename == newname

          message = ""

          if File.exists?(newname)
            if options.force
              File.delete(newname)
            else
              halt!("Cannot rename #{filename} to #{newname} - File exists! Use --force to override")
              next
            end
          end

          File.rename(filename, newname)

          if options.link
            File.delete(filename) if options.force && File.exists?(filename)
            File.symlink(newname, filename) unless newname == filename
          end

          hey("#{filename} renamed to #{newname} [#{file.entity_id}] #{message}") if options.verbose
        end

      end

    end

    private

  end

end


