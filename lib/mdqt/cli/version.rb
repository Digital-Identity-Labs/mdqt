module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Version < Base

      def run
        puts "MDQT version #{MDQT::VERSION}"
      end

    end

  end
end

