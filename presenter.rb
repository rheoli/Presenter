#!/usr/bin/env ruby
#=presenter.rb

require 'sinatra'
require 'haml'

PRESENTER_BASE=File.dirname(__FILE__)

configure(:development) do |c|
  require "sinatra/reloader"
  c.also_reload "*.rb"
end

get '/' do
  @pres=[]
  Dir.open("#{PRESENTER_BASE}/data").each do |d|
    next if d=~/^\./
    @pres<<d
  end
  haml :index
end

get '/view/:present' do
  unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}")
    return [302, {"Location"=>"/"}, ["Redirect"]]
  end
  @img="/none"
  if File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}/active")
    f=File.read("#{PRESENTER_BASE}/data/#{params["present"]}/active")
    @img="/images/#{params["present"]}/#{f}"
  end
  haml :view
end

get '/active/:present' do
  unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}/active")
    return [200, {}, ["/none"]]
  end
  f=File.read("#{PRESENTER_BASE}/data/#{params["present"]}/active")
  return [200, {}, ["/images/#{params["present"]}/#{f}"]]
end

get '/images/:present/:img' do
  unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}/img/#{params["img"]}")
    return [302, {"Location"=>"/"}, ["Redirect"]]
  end
  send_file "#{PRESENTER_BASE}/data/#{params["present"]}/img/#{params["img"]}"
end

post '/admin/:present/:img' do
  unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}/img/#{params["img"]}")
    return [200, {}, ["No such image"]]
  end
  File.open("#{PRESENTER_BASE}/data/#{params["present"]}/active", "w") do |f|
    f.puts(params["img"])
  end
  [200, {}, ["Activated"]]
end

get '/admin/:present' do
  unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}")
    return [302, {"Location"=>"/admin"}, ["Redirect"]]
  end
  @pres=[]
  Dir.open("#{PRESENTER_BASE}/data/#{params["present"]}/img").each do |d|
    next if d=~/^\./
    @pres<<d
  end
  @pres.sort!
  haml :admin_present
end

get '/admin' do
  @pres=[]
  Dir.open("#{PRESENTER_BASE}/data").each do |d|
    next if d=~/^\./
    @pres<<d
  end
  haml :admin
end

#=EOF
