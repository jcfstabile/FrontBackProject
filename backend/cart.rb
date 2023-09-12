# bussines routes
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
