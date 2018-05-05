require "spec_helper"

require 'mdqt/client'

RSpec.describe MDQT::Client::MetadataResponse do


  context "Public interface" do

    let(:http_response) { "a string" }
    before { allow(http_response).to receive(:status).and_return(200) }
    before { allow(http_response).to receive(:body).and_return("Body") }
    before { allow(http_response).to receive(:success?).and_return(true) }
    before { allow(http_response).to receive(:headers).and_return({'Content-Type' => 'application/samlmetadata+xml'}) }

    subject { MDQT::Client::MetadataResponse.new("https://example.com/shibboleth", "http://example.com/mdq", http_response) }

    it {is_expected.to respond_to :identifier}
    it {is_expected.to respond_to :requested_identifier}
    it {is_expected.to respond_to :service}
    it {is_expected.to respond_to :code}
    it {is_expected.to respond_to :data}
    it {is_expected.to respond_to :type}
    it {is_expected.to respond_to :expires}
    it {is_expected.to respond_to :etag}
    it {is_expected.to respond_to :last_modified}
    it {is_expected.to respond_to :ok?}
    it {is_expected.to respond_to :signed?}
    it {is_expected.to respond_to :filename}
    it {is_expected.to respond_to :message}

  end

end