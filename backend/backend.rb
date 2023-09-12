require 'sinatra'

controller_dir = "backend/"
frontend_dir = "frontend/"
model_dir = "model/"
$LOAD_PATH.unshift controller_dir
$LOAD_PATH.unshift model_dir

$model_in_error

class Check
  def initialize(app)
    @app = app
  end
  def infrastructure_route?(env)
    request_path = env['REQUEST_PATH']
    infrastructure_routes = ['/upload' ,'/' ,'/favicon.ico' ,'/status']
    infrastructure_routes.any? { |ir| ir == request_path }
  end
  def call(env)
    if $model_in_error && !infrastructure_route?(env)
      [503, {}, ["Model in error"]]
    else
      @app.call(env)
    end
  end
end

use Check

get '/status' do
  # TODO build json response
  status $model_in_error ? 503 : 200
  Process.pid.to_json
end

not_found do
  'endpoint not found'
end

# upload endpoint
# it:
# 1. load a new model on the backend directory
# 3. shutdown the backend server (*)
# (*) giving oportunity to load the model (**)
put '/upload' do
  tempfile = params[:file][:tempfile]
  code = tempfile.read
  File.open(model_dir+'model.rb', 'w') {
    |f| f.write code
  }
  # halt to be reloaded with just uploaded model
  Thread.new { sleep 1; Process.kill 'INT', Process.pid }
  headers \
    "Access-Control-Allow-Origin" => '*'
  halt [201, code]
end

def short_error(e)
  p e
  msg = /^.*?#<.*?>/.match(e.message).to_s
    "error: #{msg}"
end

# (**) load the model on scope
begin
  puts 'loading model'
  require 'model'
  cart = Cart.new
rescue SyntaxError, NameError, LoadError
  puts '!!!!! error loading model, clearing model'
  File.open(model_dir+'model.rb', 'w') { |f| f.write "# model was cleared couse a error loading it" }
  $model_in_error = true
else
  $model_in_error = false
end

# it sendback the frontend page
get '/' do
  send_file frontend_dir+"index.html"
end

get '/favicon.ico' do
  send_file frontend_dir+"favicon.ico"
end

get '/hello/:name' do
  "Hello #{params['name']}!!!"
end


#
# bussines routes
#
get '/cart' do
  limit=params['limit'] # int, if 0 or missing => all
  order=params['order'] # des | asc | if missing => unordered
  begin
    cart.order(order, limit.to_i).to_json
  rescue => e
    short_error(e)
  end
end

get '/cart/product/:id' do
  begin
    "... the product with id #{params['id']}"
    cart.at(params['id'].to_i).to_json
  rescue => e
    short_error(e)
  end
end

post '/cart/:id' do
  begin
    " ... create #{params['id']}"
    cart.add(params['id'].to_i).to_json
  rescue => e
    short_error(e)
  end
end

patch '/cart/:id' do
  begin
    " ... modify #{params['id']}"
    cart.change(params['id'].to_i).to_json
  rescue => e
    short_error(e)
  end
end
put '/cart/:id' do
  begin
    "... replace #{params['id']}"
    cart.remove(params['id'].to_i)
    cart.add(params['id'].to_i).to_json
  rescue => e
    short_error(e)
  end
end
delete '/cart/:id' do
  begin
   "... delete #{params['id']}"
   cart.remove(params['id'].to_i).to_json
  rescue => e
    short_error(e)
  end
end

get '/cart/total' do
  begin
    cart.total.to_json
  rescue => e
    short_error(e)
  end
end

