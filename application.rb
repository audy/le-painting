require './environment.rb'
require './helpers.rb'

class Skellington < Sinatra::Base

  # Use cookie-based sessions so that sessions are persistant
  use Rack::Session::Cookie

  register Sinatra::AssetPack

  assets do
    serve '/js',     from: 'assets/js'
    serve '/css',    from: 'assets/css'
    serve '/images', from: 'assets/images'
    serve '/img',    from: 'assets/images' # hack for literally-canvas

    # main css and javascrip including jQuery and bootstrap
    css :main, ['/css/normalize.css', '/css/style.css']
    css :forms, ['/css/pure.css']
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
    posts = Post.all(hidden: false, limit: 10, order: :id.desc)
    erb :home, locals: { posts: posts }
  end

  get '/page/:page' do
    @posts = Post.paginate(page: params[:page], per_page: 30)
  end

  get '/session/new' do
    erb :'session/new'
  end

  get '/session/destroy' do
    protect

    session[:user_id] = nil
    redirect '/'
  end

  post '/session/new' do
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
    erb :'user/new'
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

  get '/user/:id' do
    user = User.get(params[:id])
    posts = Post.all user: user, order: :id.desc
    erb :'/user/view', locals: { user: user , posts: posts }
  end

  get '/post/new' do
    protect
    erb :'post/new'
  end

  get '/post/:id' do
    post = Post.get(params[:id])
    erb :'post/view', locals: { post: post }
  end

  post '/post/:id/hide' do
    bad_user!('youre not admin!') unless admin?
    Post.get(params[:id]).update!({ hidden: true })
    session[:flash] = 'Post hidden'
    redirect '/'
  end

  # save the painting!
  post '/post/new' do
    protect

    post = Post.new file: params['image'][:tempfile],
                    user: @user,
                    title: params['title']
    if post.save
      puts "success"
      redirect '/'
    else
      puts "failure"
      p post.errors
    end
  end

  get '/post/:id/fork' do
    protect
    parent = Post.get(params[:id])
    erb :'/post/fork/new', locals: { parent: parent }
  end

  post '/post/:id/fork' do
    protect

    parent = Post.get(params[:id])
    post = Post.new file: params['image'][:tempfile],
                    user: @user,
                    title: params[:title]
    parent.forks << post
    if post.save and parent.save
      redirect "/post/#{post.id}"
    else
      # something went wrong
      fail
    end
  end
end
