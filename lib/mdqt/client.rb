module MDQT
  class Client

    require 'mdqt/client/metadata_service'

    def initialize(base_url, options={})

      @base_url   = base_url
      @verbose    = options[:verbose] || false
      @cache_type = options[:cache_type] || :none

      @md_service = MetadataService.new(@base_url, verbose: @verbose, cache_type: @cache_type)

    end

    def get_metadata(entity_id)

      md_service.get(entity_id)

    end

    def base_url
      @base_url
    end

    def verbose?
      @verbose
    end

    def cache_type
      @cache_type
    end

    private

    def md_service
      @md_service
    end

  end

end