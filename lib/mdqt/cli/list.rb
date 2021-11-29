module MDQT

  class CLI

    require 'mdqt/cli/base'

    class List < Base

      def run

        options.validate = true

        advise_on_xml_signing_support

        halt!("Cannot check a metadata file without XML support: please install additional gems") unless MDQT::Client.verification_available?

        response = get_response
        result = verify_result(response)

        puts result.entity_ids

      end

      def get_response

        client = MDQT::Client.new(
          options.service,
          verbose: options.verbose,
          explain: options.explain ? true : false,
          tls_risky: options.tls_risky ? true : false,
          cache_type: MDQT::CLI::CacheControl.cache_type(options),
        )

        client.get_metadata("")

      end

      def verify_result(result)

        if options.validate
          halt! "The data for #{result.identifier} is not valid when checked against schema:\n#{result.validation_error}" unless result.valid?
          btw "Data for #{result.identifier.empty? ? 'aggregate' : result.identifier } has been validated against schema" ## FIXME - needs constistent #label maybe?
        end

        return result unless options.verify_with

        cert_paths = extract_certificate_paths(options.verify_with)

        halt! "Data from #{options.service} is not signed, cannot verify!" unless result.signed?
        halt! "The data for #{result.identifier} cannot be verified using #{cert_paths.to_sentence}" unless result.verified_signature?(cert_paths)
        btw "Data for #{result.identifier.empty? ? 'aggregate' : result.identifier } has been verified using '#{cert_paths.to_sentence}'" ## FIXME - needs constistent #label maybe?

        result

      end

    end

    private

  end

end


