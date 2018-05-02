module MDQ
  class Client

    require 'mdq/client/metadata_service'

    def initialize(options={})

      @base_url = options[:base_url]
      @md_service = MetadataService.new(@base_url)

    end

    def get_metadata(entity_id)

      result = md_service.get(entity_id)

      puts result.body

    end

    def md_service
      @md_service
    end

    def base_url
      @base_url
    end

  end

end