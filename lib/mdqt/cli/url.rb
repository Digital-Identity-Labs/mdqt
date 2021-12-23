module MDQT

  class CLI

    require 'mdqt/cli/base'
    require 'uri'

    class URL < Base

      def run

        mds = MDQT::Client::MetadataService.new(service_url(options),
                                  verbose:false,
                                  cache_type: :none,
                                  explain: false,
                                  tls_cert_check: false)

        if args.empty?
          puts service_url(options)
        else
          args.each do |arg|
            puts build_url(mds, arg)
          end
        end

      end

      def build_url(mds, entity_id)

        URI.join(service_url(options), "/entities/#{mds.prepare_id(entity_id)}")
      end

    end

  end
end

