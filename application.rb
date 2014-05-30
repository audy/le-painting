require './environment.rb'
require 'sinatra'

class Skellington < Sinatra::Base

  # Use cookie-based sessions so that sessions are persistant
  use Rack::Session::Cookie

  register Sinatra::AssetPack

  assets do
    serve '/js',     from: 'assets/js'
    serve '/css',    from: 'assets/css'
    serve '/images', from: 'assets/images'

    # main css and javascrip including jQuery and bootstrap
    css :main, ['/css/*.css']
    js :main, ['/js/jquery-v1.10.2.js', '/js/bootstrap-v3.0.0-rc1.js']

    # literally.js stuff
    css :literally, ['/css/literally.css']
    js :literally, ['/js/literallycanvas.js', '/js/literallycanvas.jquery.js']

    css_compression :simple
    js_compression :uglify
  end

  helpers do

    def authenticate!
      redirect '/' unless @user
    end

  end

  before do
    @user = User.get(session[:user_id])
  end

  get '/' do
    @posts = Post.last(10)
    haml :home
  end

  get '/page/:page' do
    @posts = Post.paginate(page: params[:page], per_page: 30)
  end

  get '/session/new' do
    haml :'session/new'
  end

  get '/session/destroy' do
    session[:user_id] = nil
    redirect '/'
  end

  post '/session/new' do
    p params
    p params['user']['email']
    user = User.first email: params['user']['email']
    if user.has_password? params['user']['password']
      session[:user_id] = user.id
      redirect '/'
    else
      session[:flash] = 'Error: incorrect password'
      redirect '/session/new'
    end
  end

  get '/user/new' do
    haml :'user/new'
  end

  post '/user/new' do
    user = User.new name: params['user']['name'],
                    email: params['user']['email'],
                    password: params['user']['password']

    if user.save
      session[:user_id] = user.id # log user in
      redirect '/'
    else
      redirect '/user/new'
    end
  end

  get '/post/new' do
    haml :'post/new'
  end

  get '/post/:id' do
    @post = Post.get(params[:id])
    haml :'post/view'
  end

  # save the painting!
  post '/post/new' do
    post = Post.new 
    post.file = params['image'][:tempfile]
    post.user = @user
    if post.save
      puts "success"
      redirect '/'
    else
      puts "failure"
      p post.errors
    end
  end

end
