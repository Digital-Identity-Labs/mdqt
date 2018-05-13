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
              identifier.gsub("{sha1}", "") :
              uri_to_sha1(identifier)
        end

        def valid_transformed?(string)
          (string =~ /^[{]sha1[}][0-9a-f]{40}$/i).nil? ? false : true
        end

        def lazy_transformed?(string)
          (string =~ /^[\[]sha1[\]][0-9a-f]{40}$/i).nil? ? false : true
        end

        def fish_transformed?(string)
          (string =~ /^sha1[0-9a-f]{40}$/i).nil? ? false : true
        end

        def correct_lazy_transformed(lazy)
         lazy.gsub("[sha1]", "{sha1}").downcase
        end

        def correct_fish_transformed(lazy)
          lazy.gsub("sha1", "{sha1}").downcase
        end

      end

    end

  end

end