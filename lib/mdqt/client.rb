module MDQT
  class Client

    require 'rubygems'
    require 'mdqt/client/metadata_service'
    require 'mdqt/client/metadata_validator'
    require 'mdqt/client/identifier_utils'

    begin
      raise if ENV['MDQT_FAKE_MISSING_XMLSIG_GEM']
      require 'xmldsig'
      @xmlsig_available = true
    rescue LoadError => oops
      @xmlsig_available = false
    end

    def self.verification_available?
      @xmlsig_available
    end

    def initialize(base_url, options={})

      @base_url        = base_url
      @verbose         = options[:verbose] || false
      @explain         = options[:explain] || false
      @tls_cert_check  = options[:tls_risky] ? false : true
      @cache_type = options[:cache_type] || :none

      @md_service = MetadataService.new(@base_url, verbose: @verbose, cache_type: @cache_type, explain: @explain, tls_cert_check: tls_cert_check?)

    end

    def get_metadata(entity_id)

      md_service.get(entity_id)

    end

    def transform_uri(uri)
      MDQT::Client::IdentifierUtils.transform_uri(uri)
    end

    def base_url
      @base_url
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

    def cache_type
      @cache_type
    end

    def cache_reset!
      md_service.purge_cache!
    end

    private

    def md_service
      @md_service
    end

  end

end