require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'dm-core'
require 'dm-redis-adapter'
require 'dm-serializer'
require "dm-validations"
require "dm-validations-i18n"
require 'json'

Redis.current = Redis.new(host: 'localhost', port: 6379)
DataMapper.setup(:default, {adapter: "redis"})

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/tests' do
  title = params['title']
  unless title.nil? || title.empty?
    tests = Test.all(conditions: {:title.like => "%#{title}%"})
  else
    tests = Test.all
  end
  tests.to_json(only: [:id, :title])
end

get '/tests/:id' do
  id = params['id']
  begin
    Test.get!(id).to_json
  rescue => errors
    halt 404, json({errors: errors.full_messages})
  end
end

post '/tests' do
  payload = JSON.parse(request.body.read)
  now = Time.now
  test = Test.create(title: payload['title'], description: payload['description'], test: payload['test'], created_at: now, updated_at: now)
  halt 400, json({errors: test.errors.full_messages}) unless test.errors.empty?
  test.to_json
end

put '/tests/:id' do
  payload = JSON.parse(request.body.read)
  id = payload['id']
  begin
    test = Test.get!(id)
  rescue => errors
    halt 404, json({errors: errors.full_messages})
  end
  test.title = payload['title']
  test.description = payload['description']
  test.test = payload['test']
  test.updated_at = Time.now
  test.save
  halt 400, json({errors: test.errors.full_messages}) unless test.errors.empty?
  test.to_json
end

get '/*' do |path|
  send_file File.join(settings.public_folder, 'index.html')
end

class Test
  include DataMapper::Resource
  property :id, Serial
  property :title, String, index: true, required: true
  property :description, Text
  property :test, Text
  property :created_at, Time
  property :updated_at, Time
end

DataMapper.finalize
DataMapper::Validations::I18n.localize! 'ja'
