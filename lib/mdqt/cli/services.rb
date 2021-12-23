module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Services < Base

      def run

        puts "\nKnown services:"
        puts
        MDQT::CLI::Defaults.services.each do |service|
          puts "#{service[:alias]}: #{service[:url]}"
        end
        puts
        puts "Specify these in commands using the --service option or MDQ_BASE_URL environment variable"
        puts
      end

    end

  end
end

