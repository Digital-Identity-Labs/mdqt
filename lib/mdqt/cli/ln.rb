module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Ln < Base

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

          next if File.symlink?(filename)

          file = client.open_metadata(filename)

          halt!("Cannot access file #{filename}") unless file.readable?
          halt!("File #{filename} is a metadata aggregate, cannot create entityID hashed link!") if file.aggregate?
          halt!("XML validation failed for #{filename}:\n#{file.validation_error}") unless file.valid?

          halt!("Cannot find entityID for #{filename}") unless file.entity_id

          linkname = file.linkname
          halt!("Cannot link file to itself! #{filename}") if filename == linkname

          message = ""

          if File.exists?(linkname)
            if options.force
              File.delete(linkname)
            else
              old_target = File.readlink(linkname)
              message = old_target == filename ? "File exists" : "Conflicts with #{filename}"
              halt!("#{linkname} -> #{old_target} [#{file.entity_id}] #{message}. Use --force to override")
              next
            end
          end

          File.symlink(filename, linkname)
          hey("#{linkname} -> #{filename} [#{file.entity_id}] #{message}") if options.verbose
        end

      end

    end

    private

  end

end


