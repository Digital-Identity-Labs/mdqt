module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Get < Base

      def run

        aggregate_confirmation_check!

        advise_on_xml_signing_support

        results = verify_results(get_responses)

        #results = MetadataAggregator.aggregate_responses(results) if options.aggregate

        output_metadata(results, options)

      end

      def get_responses

        client = MDQT::Client.new(
            options.service,
            verbose: options.verbose,
            cache_type: options.cache ? :file : :none
        )

        args.empty? ? [client.get_metadata("")] : args.collect {|entity_id| client.get_metadata(entity_id)}

      end

      def verify_results(results)

        return results unless options.verify_with

        cert_paths = extract_certificate_paths(options.verify_with)

        results.each do |result|
          next unless result.ok?
          halt! "Data from #{options.service} is not signed, cannot verify!" unless result.data.include?('<Signature')
          halt! "The data for #{result.identifier} cannot be verified using #{cert_paths.to_sentence}" unless result.verified_signature?(cert_paths)
          btw "Data for #{result.identifier} has been verified using '#{cert_paths.to_sentence}'"
        end

        results

      end

      def output_metadata(results, options)
        case action(results, options)
        when :save_files
          output_files(results, options)
        when :print_to_stdout
          output_to_stdout(results, options)
        else
          halt! "Can't determine output type"
        end
      end

      def action(results, options)
        case
        when options.save
          :save_files
        else
          :print_to_stdout
        end
      end

      def output_to_stdout(results, options)
        results.each {|r| puts output(r)}
      end

      def output_files(results, options)
        halt! "Unimplemented feature"
      end

      private

      def format_list

      end

      def aggregate_confirmation_check!
        halt!("Please specify --all if you wish to request all entities from #{options.service}") if args.empty? && !options.all
      end

    end

  end

end
