module MDQ

  class CLI

    require 'mdq/cli/base'

    class Get < Base

      def run(args, options)



        client = MDQ::Client.new(base_url: 'http://mdq.ukfederation.org.uk/')


        client.get_metadata(args[0])

      end

    end

  end

end
