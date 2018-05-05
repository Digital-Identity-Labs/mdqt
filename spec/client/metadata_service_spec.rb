require "spec_helper"
require 'mdqt/client/metadata_service'

RSpec.describe MDQT::Client::MetadataService do

  context "Public interface" do

    subject { MDQT::Client::MetadataService.new("http://example.com/mdq") }

    it {is_expected.to respond_to :get}
    it {is_expected.to respond_to :base_url}
    it {is_expected.to respond_to :prepare_id}
    it {is_expected.to respond_to :verbose?}
    it {is_expected.to respond_to :cache?}
    it {is_expected.to respond_to :cache_type}
    it {is_expected.to respond_to :store_config}

  end

  context 'My context' do


  end

end