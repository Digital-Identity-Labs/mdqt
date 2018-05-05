require "spec_helper"
require 'mdqt/client'

RSpec.describe MDQT::Client do

  context 'Public Interface' do

    subject {MDQT::Client.new("https://mdq.example.com/mdq")}

    it {is_expected.to respond_to :get_metadata}
    it {is_expected.to respond_to :base_url}
    it {is_expected.to respond_to :verbose?}
    it {is_expected.to respond_to :cache_type}

  end

  describe '#verbose' do

    context 'when not set as an option in #new' do
      subject {MDQT::Client.new("https://mdq.example.com/mdq")}
      it "returns false" do
        expect(subject.verbose?).to be false
      end
    end

    context 'when set to true as an option in #new' do
      subject {MDQT::Client.new("https://mdq.example.com/mdq", verbose: true)}
      it "returns true" do
        expect(subject.verbose?).to be true

      end
    end

    context 'when set to false as an option in #new' do
      subject {MDQT::Client.new("https://mdq.example.com/mdq", verbose: false)}
      it "returns false" do
        expect(subject.verbose?).to be false
      end
    end

  end

  describe '#base_url' do
    context 'when not set as an option in #new' do
      it "has already raised an exception" do
        expect { MDQT::Client.new() }.to raise_exception ArgumentError
      end
    end

    context 'when set to a URL in #new' do
      let(:base_url) { "https://mdq.example.com/mdq" }
      subject {MDQT::Client.new(base_url)}
      it "returns that URL" do
        expect(subject.base_url).to be base_url
      end
    end

  end

  describe '#cache_type' do

    context 'when not set as an option in new' do
      subject {MDQT::Client.new("https://mdq.example.com/mdq")}
      it "returns false" do
        expect(subject.cache_type).to be :none
      end
    end

    context 'when set to :file as an option in new' do
      subject {MDQT::Client.new("https://mdq.example.com/mdq", cache_type: :file)}
      it "returns true" do
        expect(subject.cache_type).to be :file
      end
    end

  end


end