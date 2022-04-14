module MDQT

  class CLI

    class Base

      require 'mdqt/cli'
      require 'pastel'
      require 'pathname'

      def self.run(args, options)

        check_requirements(options)
        introduce(options)

        self.new(args, options).run
      end

      def self.check_requirements(options)

        unless options.service == :not_required
          abort "No MDQ service URL has been specified. Please use --service, MDQT_SERVICE or MDQ_BASE_URL" unless service_url(options).to_s.start_with?("http")
        end

        if options.save_to
          dir = options.save_to
          begin
            FileUtils.mkdir_p(dir) unless File.exist?(dir)
          rescue
            abort "Error: Directory #{dir} did not exist, and we can't create it"
          end
          abort "Error: '#{dir}' is not a writable directory!" if (File.directory?(dir) && !File.writable?(dir))
          abort "Error: '#{dir}' is not a directory!" unless File.directory?(dir)
        end

      end

      def self.introduce(options)
        if options.verbose
          STDERR.puts "MDQT version #{MDQT::VERSION}"
          STDERR.puts "Using #{service_url(options)}" unless options.service == :not_required
          STDERR.puts "Caching is #{MDQT::CLI::CacheControl.caching_on?(options) ? 'on' : 'off'}"
          STDERR.print "XML validation is #{MDQT::Client.verification_available? ? 'available' : 'not available'}"
          STDERR.puts " #{options.validate ? "and active" : "but inactive"} for this request" if MDQT::Client.verification_available?
          STDERR.print "Signature verification is #{MDQT::Client.verification_available? ? 'available' : 'not available'}"
          STDERR.puts " #{options.verify_with ? "and active" : "but inactive"} for this request" if MDQT::Client.verification_available?
          STDERR.puts "Output directory for saved files is: #{File.absolute_path(options.save_to)}" if options.save_to
          STDERR.puts("Warning! TLS certificate verification has been disabled!") if options.tls_risky
          STDERR.puts
        end
      end

      def initialize(cli_args, options)
        piped_input = get_stdin
        @args = cli_args.concat(piped_input)
        @options = options
      end

      def get_stdin
        return $stdin.readlines.map(&:split).flatten.map(&:strip) if pipeable?
        []
      end

      def pipeable?
        return false if ENV["MDQT_STDIN"].to_s.strip.downcase == "off" # Workaround Aruba testing weirdness?
        !STDIN.tty? && !$stdin.closed? && $stdin.stat.pipe?
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

      def self.service_url(options)

        return nil if options.service == :not_required

        choice = options.service.to_s.strip

        if choice.downcase.start_with? "http"
          choice
        else
          Defaults.lookup_service_alias(choice)
        end

      end

      def service_url(options)
        self.class.service_url(options)
      end

      def output(response)
        if response.ok?
          yay response.message
          hey explain(response) if options.explain
          trailer = response.data[-1] == "\n" ? "" : "\n"
          response.data + trailer
        else
          hey response.message
        end

      end

      def explain(response)
        unless response.explanation.empty?
          require 'terminal-table'
          misc_rows = [['URL', response.explanation[:url]], ["Method", response.explanation[:method]], ['Status', response.explanation[:status]]]
          req_header_rows = response.explanation[:request_headers].map { |k, v| ['C', k, v] }
          resp_header_rows = response.explanation[:response_headers].map { |k, v| ['S', k, v] }

          btw Terminal::Table.new :title => "HTTP Misc", :rows => misc_rows
          btw Terminal::Table.new :title => "Client Request Headers", :headings => ['C/S', 'Header', 'Value'], :rows => req_header_rows
          btw Terminal::Table.new :title => "Server Response Headers", :headings => ['C/S', 'Header', 'Value'], :rows => resp_header_rows

        end
      end

      def advise_on_xml_signing_support
        hey "XML signature verification and XML validation are not available. Install the 'xmldsig' gem if you can." unless MDQT::Client.verification_available?
      end

      def extract_certificate_paths(cert_paths = options.verify_with)
        cert_paths.collect do |cert_path|
          begin
            halt! "Cannot read certificate at '#{cert_path}'!" unless File.readable?(cert_path)
            halt! "File at '#{cert_path}' does not seem to be a PEM format certificate" unless IO.binread(cert_path).include?("-----BEGIN CERTIFICATE-----")
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

      def say(text)
        STDOUT.puts(text)
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

      private

    end

  end

  #
end

