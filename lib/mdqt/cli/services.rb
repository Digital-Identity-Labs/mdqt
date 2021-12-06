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
        puts "Specify these in commands using the --service option, or set for a session with mdqt use [url]"
        puts
      end

    end

  end
end

