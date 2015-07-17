require 'sinatra'
require 'slim'
require 'markdown'
require 'stylus'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/*' do |path|
  send_file File.join(settings.public_folder, 'index.html')
end
