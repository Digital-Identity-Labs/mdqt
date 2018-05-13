module MDQT
  class Client

    module IdentifierUtils

      require 'digest'

      class << self

        def uri_to_sha1(uri)
          raise "An empty string cannot be transformed" if uri.empty?
          Digest::SHA1.hexdigest(uri.to_s.strip)
        end

        def transform_uri(uri)
          "{sha1}#{uri_to_sha1(uri)}"
        end

        def normalize_to_sha1(identifier)
          identifier.start_with?("{sha1}") ?
              identifier.gsub("{sha1}","") :
              uri_to_sha1(identifier)
        end

      end

    end

  end

end