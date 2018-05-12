module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Get < Base

      def run

        abort("Please specify --all if you wish to request all entities from #{options.service}") if args.empty? && !options.all

        STDERR.puts "XML signature validation is not available. Install the 'nokogiri-xmlsec-instructure' gem if you can." unless MDQT::Client.verification_available?

        results = get_results(args, options)

        results = verify_results(results)

        #results = MetadataAggregator.aggregate_responses(results) if options.aggregate

        output_metadata(results, options)

      end

      def get_results(args, options)

        client = MDQT::Client.new(
            options.service,
            verbose: options.verbose,
            cache_type: options.cache ? :file : :none
        )

        args.empty? ? [client.get_metadata("")] : args.collect {|entity_id| client.get_metadata(entity_id)}

      end

      def verify_results(results)

        return results unless options.verify_with

        cert_path = options.verify_with

        abort "Error: Cannot find certificate at '#{cert_path}'!" unless File.readable?(cert_path)

        results.each do |result|
          abort "Data from #{options.service} is not signed, cannot verify!" unless result.data.include?('<Signature')
          abort "Error: The data for #{result.identifier} cannot be verified with certificate at #{cert_path}" unless result.verified_signature?(cert_path)
          STDERR.puts "Data for #{result.identifier} has been verified using certificate at '#{cert_path}'" if options.verbose
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
          abort "Error - can't determine output type"
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
        abort "Unimplemented feature"
      end

    end

  end

end
