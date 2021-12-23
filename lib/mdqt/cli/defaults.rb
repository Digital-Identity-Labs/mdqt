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
            cache: true,
            refresh: false
          }
        end

        def guess_service

          locale = ENV['LANG']

          service = services.find { |s| s[:locale] == locale }
          #service ||= services.first

          if service
            url = service[:url]
            STDERR.puts "MDQT is assuming that you want to use #{url}\nPlease configure this using --service, MDQT_SERVICE or MDQ_BASE_URL\n\n"
            url
          else
            nil
          end

        end

        def lookup_service_alias(srv_alias)
          service = services.find { |s| s[:alias].to_s.downcase.to_sym == srv_alias.to_s.downcase.to_sym }
          service ? service[:url] : nil
        end

        def services
          [
            { alias: "ukamf",
              locale: "en_GB.UTF-8",
              url: "http://mdq.ukfederation.org.uk/"
            },
            { alias: "incommon",
              locale: "en_US.UTF-8",
              url: "https://mdq.incommon.org/"
            },
            { alias: "dfn",
              locale: "de_utf8",
              url: "https://mdq.aai.dfn.de"
            },
          ]
        end

      end

    end

  end
end