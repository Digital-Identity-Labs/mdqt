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
      require 'active_support/notifications'

      require_relative './metadata_response'

      def initialize(base_url, options = {})
        @base_url = base_url
        @cache_type = options[:cache_type] ? options[:cache_type].to_sym : :none
        @store_config = options[:cache_store]
        @verbose = options[:verbose] ? true : false
        @explain = options[:explain] ? true : false
        @tls_cert_check = options[:tls_cert_check] ? true : false
      end

      def base_url
        @base_url
      end

      def get(entity_id)

        entity_id = prepare_id(entity_id)

        begin
          http_response = connection.get do |req|
            req.url request_path(entity_id)
            req.options.timeout = 1000
            req.options.open_timeout = 60
          end
        rescue Faraday::ConnectionFailed => oops
          abort "Error - can't connect to MDQ service at URL #{base_url}: #{oops.to_s}"
        rescue Faraday::TimeoutError => oops
          abort "Error - connection to #{base_url} timed out!"
        end

        MetadataResponse.new(entity_id, base_url, http_response, explain: explain?)

      end

      def exists?(entity_id)

        entity_id = prepare_id(entity_id)

        begin
          http_response = connection.head do |req|
            req.url request_path(entity_id)
            req.options.timeout = 1000
            req.options.open_timeout = 60
          end
        rescue Faraday::ConnectionFailed => oops
          abort "Error - can't connect to MDQ service at URL #{base_url}: #{oops.to_s}"
        rescue Faraday::TimeoutError => oops
          abort "Error - connection to #{base_url} timed out!"
        end

        http_response.status == 200

      end
      def prepare_id(id)
        case id
        when :all, "", nil
          ""
        when /^{sha1}/i
          CGI.escape(validate_sha1!(id.downcase.strip))
        when /^\[sha1\]/i
          CGI.escape(validate_sha1!(id.downcase.strip.gsub "[sha1]", "{sha1}"))
        else
          CGI.escape(id.strip)
        end
      end

      def verbose?
        @verbose
      end

      def explain?
        @explain
      end

      def tls_cert_check?
        @tls_cert_check
      end

      def cache?
        cache_type == :none ? false : true
      end

      def cache_type
        @cache_type || :none
      end

      def store_config
        @store_config || default_store_config
      end

      def validate_sha1!(sha1)
        abort "Error: SHA1 identifier '#{sha1}' is malformed, halting" unless valid_sha1?(sha1)
        sha1
      end

      def valid_sha1?(sha1)
        (sha1 =~ /^[{\[]sha1[\]}][0-9a-f]{40}$/i).nil? ? false : true
      end

      def tidy_cache!
        cache_type.cleanup
      end

      def purge_cache!
        cache_store.clear
      end

      private

      def request_path(entity_id)
        case entity_id
        when nil, ""
          'entities'
        else
          ['entities', entity_id].join('/')
        end
      end

      def connection
        Faraday.new(:url => base_url) do |faraday|
          faraday.request :url_encoded
          faraday.use FaradayMiddleware::Gzip
          faraday.use FaradayMiddleware::FollowRedirects
          if cache?
            faraday.use :http_cache,
                        store: cache_store,
                        shared_cache: false,
                        serializer: Marshal,
                        instrumenter: ActiveSupport::Notifications
          end
          faraday.ssl.verify = tls_cert_check?
          faraday.headers['Accept'] = 'application/samlmetadata+xml'
          faraday.headers['Accept-Charset'] = 'utf-8'
          faraday.headers['User-Agent'] = "MDQT v#{MDQT::VERSION}"
          #faraday.response :logger
          faraday.adapter :typhoeus
        end
      end

      def default_store_config
        case cache_type
        when :none, nil
          nil
        when :file, :files
          File.absolute_path(File.join(Dir.tmpdir, 'mdqt_cache'))
        when :memcached, :memcache
          'localhost:11211'
        end
      end

      def cache_logger
        verbose? ? Logger.new('mdqt_cache.log') : nil
      end

      def cache_store
        case cache_type
        when :file, :files, nil
          @cache_store = ActiveSupport::Cache.lookup_store(:file_store, store_config)
        when :memcache, :memcached
          @cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, [store_config])
        end
      end

    end

  end

end