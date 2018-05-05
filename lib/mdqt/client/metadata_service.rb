module MDQT
  class Client

    class MetadataService

      require 'faraday'
      require 'typhoeus'
      require 'typhoeus/adapters/faraday'
      require 'cgi'

      require 'faraday_middleware'
      require 'faraday-http-cache'

      require 'active_support/cache'
      require 'active_support/cache/file_store'
      require 'active_support/cache/mem_cache_store'
      require 'active_support/logger'

      require_relative './metadata_response'

      def initialize(base_url, options={})

        @base_url = base_url

      end

      def base_url
        @base_url
      end

      def get(entity_id)

        entity_id = prepare_id(entity_id)

        http_response = connection.get do |req|
          req.url ['entities/', entity_id].join
          req.options.timeout = 100
          req.options.open_timeout = 5
          req.headers['Content-Type'] = 'application/samlmetadata+xml'
          req.headers['User-Agent'] = "MDQT v#{MDQT::VERSION}"
        end

        MetadataResponse.new(entity_id, base_url, http_response)

      end

      def prepare_id(id)
        case id
        when :all, "", nil
          ""
        when /^{sha1}/i
          CGI.escape(id.downcase.strip)
        when /^\[sha1\]/i
          CGI.escape(id.downcase.strip.gsub "[sha1]", "{sha1}")
        else
          CGI.escape(id.strip)
        end
      end

      def connection
        Faraday.new(:url => base_url) do |faraday|
          faraday.request :url_encoded
          #faraday.use :http_cache, store: cache_store, shared_cache: false, serializer: Marshal, logger: ActiveSupport::Logger.new(STDERR)
          #faraday.response :logger
          faraday.adapter :typhoeus

        end
      end

      def cache_store
        #Dir.mktmpdir("mdqt")
        #@cache_store ||= ActiveSupport::Cache.lookup_store(:mem_cache_store, ['localhost:11211'])
        #@cache_store ||= ActiveSupport::Cache.lookup_store(:file_store, "/tmp/mdqt")
      end

    end

  end

end