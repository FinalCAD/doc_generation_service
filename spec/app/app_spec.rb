require 'spec_helper'

describe 'App' do
  include Rack::Test::Methods

  let(:options) do
    { :name => 'name of document',
      :document_type => :xls,
      :test => true,
      :async => true,
      :callback_url =>
        'http://0.0.0.0:3000/documents?token=344e4ef12958e18247fef964be5b27047632a305',
      :document_url =>
        'spec/fixtures/file.html',
      :token => '1234',
      :prince_options =>  { :version => '9.0', :http_timeout => '60' }
    }
  end

  specify do
    expect(Registry.instance.status(options[:token])[:status]).to eq(Registry::UNKNOWN)
  end

  describe '#docs' do
    let(:auth) do  { :username => 'api_key' } end
    let(:document) { double('document') }
    let(:request)  { double('request') }

    before do
      allow(Document).to receive(:new) { document }
      expect(document).to receive(:generate!) { nil }
      allow(RestClient::Request).to receive(:new) { request }
      expect(request).to receive(:execute) { nil }
    end

    subject do
      post '/docs', options, basic_auth: auth
    end

    specify do
      expect(subject.status).to eq(200)
    end

    specify do
      expect(JSON.parse(subject.body)['status_id']).to eq(options[:token])
    end

  end
end
