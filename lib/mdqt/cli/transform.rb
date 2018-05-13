module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Transform < Base

      def run

        client = MDQT::Client.new(
            options.service,
            verbose: options.verbose,
            explain: options.explain ? true : false,
            cache_type: options.cache ? :file : :none,
            )

        halt!("No entityIDs have been specified!") if args.empty?

        args.each do |arg|
          puts client.transform_uri(arg)
        end

      end

    end

  end
end

