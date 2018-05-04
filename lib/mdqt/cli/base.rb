module MDQT

  class CLI

    class Base

      def self.run(args, options)

        #args = options.stdin ? absorb_piped_args(args) : args

        check_requirements(args, options)
        introduce(args, options)

        self.new(args, options).run
      end

      def self.check_requirements(args, options)
        abort "Error: No MDQ service URL has been specified." unless options.service
      end

      def self.introduce(args, options)
        if options.verbose
          STDERR.puts "Using #{options.service}"
        end
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
          STDERR.puts response.message if options.verbose
          trailer = response.data[-1] == "\n" ? "" : "\n"
          response.data + trailer
        else
          STDERR.puts response.message
        end

      end

      def run

        abort "No action has been defined for this command!"

      end

    end

  end
#
end

