#=presenter.rb

require 'sinatra'
require 'haml'

configure(:development) do |c|
  require "sinatra/reloader"
  c.also_reload "*.rb"
end

get '/' do
  haml :index
end

#=EOF
