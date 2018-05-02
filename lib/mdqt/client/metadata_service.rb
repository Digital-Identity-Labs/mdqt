module MDQT
  class Client

    class MetadataService

      require 'faraday'
      require 'typhoeus'
      require 'typhoeus/adapters/faraday'
      require 'cgi'

      def initialize(base_url)

        @base_url = base_url

      end

      def base_url
        @base_url
      end

      def get(entity_id)

        entity_id = prepare_id(entity_id)

        connection.get do |req|
          req.url ['entities/', entity_id].join
          req.options.timeout = 100
          req.options.open_timeout = 5
          req.headers['Content-Type'] = 'application/samlmetadata+xml'
          req.headers['User-Agent'] = "MDQT v#{MDQT::VERSION}"
        end
      end

      def prepare_id(id)
        case id
        when :all, "", nil
          ""
        when /^{sha1}/i
          CGI.escape(id.downcase.strip)
        when /^\[sha1\]/i
          CGI.escape(id.downcase.strip.gsub"[sha1]","{sha1}")
        else
          CGI.escape(id.strip)
        end
      end

      def connection
        Faraday.new(:url => base_url) do |faraday|
          faraday.request :url_encoded
          #faraday.response :logger                  # log requests to STDOUT
          faraday.adapter :typhoeus
        end
      end

    end

  end

end