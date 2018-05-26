module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Check < Base

      def run

        options.validate = true

        advise_on_xml_signing_support
        halt!("Cannot check a metadata file without XML support: please install additional gems") unless MDQT::Client.verification_available?

        client = MDQT::Client.new(
            options.service,
            verbose: options.verbose,
            explain: options.explain ? true : false,
            )

        cert_paths = options.verify_with ? extract_certificate_paths(options.verify_with) : []

        args.each do |filename|

          filename = File.absolute_path(filename)
          file = client.open_metadata(filename)

          halt!("Cannot access file #{filename}") unless file.readable?

          halt!("XML validation failed for #{filename}:\n#{file.validation_error}") unless file.valid?
          btw"File #{filename} is valid SAML Metadata XML"


          if options.verify_with
            halt! "XML in #{filename} is not signed, cannot verify!" unless file.signed?
            halt! "The signed XML for #{filename} cannot be verified using #{cert_paths.to_sentence}" unless file.verified_signature?(cert_paths)
            btw "Signed XML for #{filename} has been verified using '#{cert_paths.to_sentence}'"
          end

          yay "#{filename} OK"
        end


      end


      def verify_results(results)

        # if options.validate
        #   results.each do |result|
        #     next unless result.ok?
        #     halt! "The data for #{result.identifier} is not valid when checked against schema:\n#{result.validation_error}" unless result.valid?
        #     btw "Data for #{result.identifier.empty? ? 'aggregate' : result.identifier } has been validated against schema" ## FIXME - needs constistent #label maybe?
        #   end
        # end
        #
        # return results unless options.verify_with
        #
        # cert_paths = extract_certificate_paths(options.verify_with)
        #
        # results.each do |result|
        #   next unless result.ok?
        #   halt! "Data from #{options.service} is not signed, cannot verify!" unless result.signed?
        #   halt! "The data for #{result.identifier} cannot be verified using #{cert_paths.to_sentence}" unless result.verified_signature?(cert_paths)
        #   btw "Data for #{result.identifier.empty? ? 'aggregate' : result.identifier } has been verified using '#{cert_paths.to_sentence}'" ## FIXME - needs constistent #label maybe?
        # end
        #
        # results

      end

    end

    private


  end

end


