module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Get < Base

      def run(args, options)

        client = MDQT::Client.new(base_url: options.service)

        if args.empty?

          if options.all
            results = [client.get_metadata("")]
          else
            abort("Please specify --all if you wish to request all entities from #{options.service}")
          end

        else
          results = args.collect {|entity_id| client.get_metadata(entity_id)}
        end

        results.each do |result|
          puts result.body
        end

      end
      
    end

  end

end
