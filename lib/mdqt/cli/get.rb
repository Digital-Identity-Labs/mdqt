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
            explain: options.explain ? true : false,
            cache_type: options.cache ? :file : :none,
        )

        args.empty? ? [client.get_metadata("")] : args.collect {|entity_id| client.get_metadata(entity_id)}

      end

      def verify_results(results)

        if options.validate
          results.each do |result|
            next unless result.ok?
            halt! "The data for #{result.identifier} is not valid when checked against schema:\n#{result.validation_error}" unless result.valid?
            btw "Data for #{result.identifier.empty? ? 'aggregate' : result.identifier } has been validated against schema" ## FIXME - needs constistent #label maybe?
          end
        end

        return results unless options.verify_with

        cert_paths = extract_certificate_paths(options.verify_with)

        results.each do |result|
          next unless result.ok?
          halt! "Data from #{options.service} is not signed, cannot verify!" unless result.signed?
          halt! "The data for #{result.identifier} cannot be verified using #{cert_paths.to_sentence}" unless result.verified_signature?(cert_paths)
          btw "Data for #{result.identifier.empty? ? 'aggregate' : result.identifier } has been verified using '#{cert_paths.to_sentence}'" ## FIXME - needs constistent #label maybe?
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
        when options.save_to
          :save_files
        else
          :print_to_stdout
        end
      end

      def output_to_stdout(results, options)
        results.each {|r| puts output(r)}
      end

      def output_files(results, options)
        prepare_output_directory(options.save_to)
        results.each do |result|
          main_file = output_file_path(result.filename)
          open(main_file, 'w') {|f|
            f.puts result.data
          }
          yay "Created #{main_file}"

          if options.link_id
            ["{sha1}#{result.filename.gsub(".xml", "")}"].each do |altname|
              full_alias = output_file_path(altname)
              FileUtils.ln_sf(main_file, full_alias)
              yay "Linked alias #{altname} -> #{main_file}"
            end
          end

        end
      end

      private

      def output_file_path(filename)
        File.absolute_path(File.join([options.save_to, filename]))
      end

      def prepare_output_directory(directory)
        FileUtils.mkdir_p(directory)
      end

      def aggregate_confirmation_check!
        halt!("Please specify --all if you wish to request all entities from #{options.service}") if args.empty? && !options.all
      end

    end

  end

end
