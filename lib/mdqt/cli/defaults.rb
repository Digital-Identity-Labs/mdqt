module MDQT
  class CLI

    class Defaults

      class << self

        def base_url
          ENV['MDQT_SERVICE'] || ENV['MDQ_BASE_URL'] || 'http://mdq.ukfederation.org.uk/'
        end

        def force_hash?
          false
        end

        def cli_defaults
          {
            service: base_url,
            hash: force_hash?,
          }
        end

      end

    end

  end
end