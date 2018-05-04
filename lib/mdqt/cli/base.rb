module MDQT

  class CLI

    class Base

      def self.run(args, options)

        #args = options.stdin ? absorb_piped_args(args) : args

        self.new(args, options).run
      end

      def self.absorb_piped_args(args)
        piped = piped? ? parse_stdin : []
        args + piped
      end

      def self.piped?
        !STDIN.tty? && !STDIN.closed?
      end

      def self.parse_stdin
        STDIN.gsub("\s", "\n").each_line.collect {|l| l.strip }
      end

      def initialize(args, options)
        @args = args
        @options = options
      end

      def args=(new_args)
        @args = new_args
      end

      def args
        @args
      end

      def options=(new_options)
        @options = new_options
      end

      def options
        @options
      end

      def output(response)
        if response.ok?
          response.data + "\n"
        else
          STDERR.puts response.error_message
        end

      end

      def run

        abort "No action has been defined for this command!"

      end

    end

  end
#
end

