module MDQT

  class CLI

    class Base

      def self.run(args, options)
        self.new.run(args, options)
      end

      def run(args, options)

        puts "No action has been defined for this command!"

      end

    end

  end
#
end

