$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mdqt"
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :faraday
end
#
# def stub_request(conn, adapter_class = Faraday::Adapter::Test, &stubs_block)
#   adapter_handler = conn.builder.handlers.find {|h| h.klass < Faraday::Adapter }
#   conn.builder.swap(adapter_handler, adapter_class, &stubs_block)
# end


