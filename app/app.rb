require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'rest-client'

require_relative 'registry'
require_relative 'document'

begin
  require 'pry'
rescue LoadError
end

class PrinceXmlWrapper < Sinatra::Application

  post '/docs' do
    url          = params.fetch('document_url')
    token        = params.fetch('token')
    type         = params.fetch('document_type')
    callback_url = params.fetch('callback_url')

    Document.new.generate! token, url, type

    data, headers = {}, {}
    request  = RestClient::Request.new(method: :post, url: callback_url, payload: data, headers: headers)
    response = request.execute

    { status_id: token }.to_json
  end

  get '/status' do
    status = Registry.instance.status(params['id'])[:status]
    binding.pry
    { status: status, download_url: "http://#{request.host_with_port}/files?id=#{params['id']}" }.to_json
  end

  get '/files' do
    send_file File.new(Registry.instance.status(params['id'])[:url])
  end
end
