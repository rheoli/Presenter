#!/usr/bin/env ruby
#=presenter.rb

PRESENTER_BASE=File.dirname(__FILE__)

$: << PRESENTER_BASE+"/lib"

#require 'redis' 
#require 'redis/connection/synchrony' 

require 'goliath'
require 'goliath/rack/templates'

class Presenter < Goliath::API
  include Goliath::Rack::Templates

  use ::Rack::Reloader

  use Goliath::Rack::Params
  use(Rack::Static,
        :root => Goliath::Application.app_path("public"),
        :urls => ["/favicon.ico", '/stylesheets', '/javascripts', '/images'])
  #use Goliath::Rack::DefaultMimeType    # cleanup accepted media types
  #use Goliath::Rack::Render             # auto-negotiate response format

  def get_index(_env)
    @pres=[]
    Dir.open("#{PRESENTER_BASE}/data").each do |d|
      next if d=~/^\./
      @pres<<d
    end
    return [200, {}, haml(:index)]
  end
  
  def get_view(_env, _param)
    unless File.exist?("#{PRESENTER_BASE}/data/#{_param}")
      return [302, {"Location"=>"/"}, ["Redirect"]]
    end
    @img="/none"
    if File.exist?("#{PRESENTER_BASE}/data/#{_param}/active")
      f=File.read("#{PRESENTER_BASE}/data/#{_param}/active")
      @img="/images/#{_param}/#{f}"
    end
    return [200, {}, haml(:view)]
  end

  def get_active(_env, _param)
    unless File.exist?("#{PRESENTER_BASE}/data/#{_params}/active")
      return [200, {}, ["/none"]]
    end
    f=File.read("#{PRESENTER_BASE}/data/#{_param}/active")
    return [200, {}, ["/images/#{_param}/#{f}"]]
  end
  
  def get_images(_env, _param)
    unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}/img/#{params["img"]}")
      return [302, {"Location"=>"/"}, ["Redirect"]]
    end
    send_file "#{PRESENTER_BASE}/data/#{params["present"]}/img/#{params["img"]}"
  end
  
  def post_admin_img(_env, _param)
    unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}/img/#{params["img"]}")
      return [200, {}, ["No such image"]]
    end
    File.open("#{PRESENTER_BASE}/data/#{params["present"]}/active", "w") do |f|
      f.puts(params["img"])
    end
    [200, {}, ["Activated"]]
  end
  
  def get_admin(_env, _param)
    unless File.exist?("#{PRESENTER_BASE}/data/#{params["present"]}")
      return [302, {"Location"=>"/admin"}, ["Redirect"]]
    end
    @pres=[]
    Dir.open("#{PRESENTER_BASE}/data/#{params["present"]}/img").each do |d|
      next if d=~/^\./
      @pres<<d
    end
    @pres.sort!
    return [200, {}, haml(:admin)]
  end
  
  def get_admin_index(_env)
    @pres=[]
    Dir.open("#{PRESENTER_BASE}/data").each do |d|
      next if d=~/^\./
      @pres<<d
    end
    return [200, {}, haml(:admin_index)]
  end

  def response(env)
    if env['REQUEST_PATH']=="/"
      return get_index(env)
    end
    if env['REQUEST_PATH']=~/^\/view\/(.+)$/
      return get_view(env, $1)
    end
    if env['REQUEST_PATH']=~/^\/active\/(.+)$/
      return get_active(env, $1)
    end
    if env['REQUEST_PATH']=~/^\/images\/(.+)$/
      return get_images(env, $1)
    end
    if env['REQUEST_PATH']=~/^\/admin\/(.+)$/
      return post_admin_img(env, $1)
    end
    if env['REQUEST_PATH']=~/^\/admin\/(.+)$/
      return get_admin(env, $1)
    end
    if env['REQUEST_PATH']=~/^\/admin\/?$/
      return get_admin_index(env)
    end
  end

end

#=EOF
