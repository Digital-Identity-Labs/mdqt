module MDQT

  class CLI

    class Base

      require 'pastel'

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
          STDERR.puts "Caching is #{options.cache ? 'on' : 'off'}"
          STDERR.print "Signature verification is #{MDQT::Client.verification_available? ? 'available' : 'not available'}"
          STDERR.puts  "#{options.verify_with ? " and active" : "but inactive "} for this request" if MDQT::Client.verification_available?
          STDERR.puts
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
        STDIN.gsub("\s", "\n").each_line.collect {|l| l.strip}
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
          yay response.message
          trailer = response.data[-1] == "\n" ? "" : "\n"
          response.data + trailer
        else
          hey response.message
        end

      end

      def advise_on_xml_signing_support
        hey "XML signature validation is not available. Install the 'nokogiri-xmlsec-instructure' gem if you can." unless MDQT::Client.verification_available?
      end

      def extract_certificate_paths(cert_paths = options.verify_with)
        cert_paths.collect do |cert_path|
          begin
            halt! "Cannot read certificate at '#{cert_path}'!" unless File.readable?(cert_path)
            halt! "File at '#{cert_path} does not seem to be a PEM format certificate'" unless IO.binread(cert_path).include?("-----BEGIN CERTIFICATE-----")
            cert_path
          rescue
            halt! "Unable to validate the certificate at '#{cert_path}'"
          end
        end
      end

      def colour_shell?
        TTY::Color.color?
      end

      def pastel
        @pastel ||= Pastel.new
      end

      def hey(comment)
        STDERR.puts(comment)
      end

      def btw(comment)
        STDERR.puts(comment) if options.verbose
      end

      def yay(comment)
        btw pastel.green(comment)
      end

      def halt!(comment)
        abort pastel.red("Error: #{comment}")
      end

      def run
        halt! "No action has been defined for this command!"
      end

    end

  end
#
end

