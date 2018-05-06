module MDQT
  class CLI

    class Defaults

      class << self

        def base_url
          ENV['MDQT_SERVICE'] || ENV['MDQ_BASE_URL'] || guess_service
        end

        def force_hash?
          false
        end

        def cli_defaults
          {
            hash: force_hash?,
            cache: false
          }
        end

        def guess_service

          locale = ENV['LANG']

          #STDERR.puts("Detected locale #{locale}")

          service = case locale
                    when 'en_GB.UTF-8'
                      'http://mdq.ukfederation.org.uk/'
                    when 'en_US.UTF-8'
                      'http://mdq-beta.incommon.org/global'
                    else
                      abort "Please specify an MDQ service using --service, MDQT_SERVICE or MDQ_BASE_URL"
                    end

          STDERR.puts "MDQT is assuming that you want to use #{service}\nPlease configure this using --service, MDQT_SERVICE or MDQ_BASE_URL\n\n"

          service

        end

      end

    end

  end
end