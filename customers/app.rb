#!/usr/bin/env ruby

require 'sinatra'
require 'json'

get '/' do
  content_type :json
  [200, {foo: 'bar'}.to_json]
end
