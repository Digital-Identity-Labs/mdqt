module MDQ

  class CLI

    require 'mdq/cli/base'

    class Get < Base

      def run(args, options)

        client = MDQ::Client.new(base_url: options.service)

        if args.empty?
          results = [client.get_metadata("")]
        else
          results = args.collect {|entity_id| client.get_metadata(entity_id)}
        end
      end

    end

  end

end
