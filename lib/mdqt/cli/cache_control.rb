module MDQT
  class CLI

    class CacheControl

      class << self

        def caching_on?(options)
          return false if cache_type(options) == :none
          true
        end

        def cache_type(options)
          return :none if options.refresh
          return :memcache if options.cache && options.memcache
          return :file if options.cache
          :none
        end

      end

    end
  end

end
