module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Reset < Base

      def run

        client = MDQT::Client.new(
            :not_required,
            verbose: false,
            cache_type: :file
        )

        print "Removing all cached files... "
        client.cache_reset!
        yay "done."

      end

    end

  end
end

