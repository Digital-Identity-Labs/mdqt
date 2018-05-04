module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Get < Base

      def run

        abort("Please specify --all if you wish to request all entities from #{options.service}") if args.empty? && !options.all

        results = get_results(args, options)

        #results = MetadataValidator.validate_responses(results) if options.validate

        #results = MetadataAggregator.aggregate_responses(results) if options.aggregate

        output_metadata(results, options)

      end

      def get_results(args, options)

        client = MDQT::Client.new(base_url: options.service)

        args.empty? ? [client.get_metadata("")] : args.collect {|entity_id| client.get_metadata(entity_id)}

      end



      def action(results, options)
        case
        when options.save
          :save_files
        else
          :print_to_stdout
        end
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

      def output_to_stdout(results, options)
        results.each {|r| puts r.data + "\n"}
      end

      def output_files(results, options)
        abort "Unimplemented feature"
      end

    end

  end

end
