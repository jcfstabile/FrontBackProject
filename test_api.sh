function request(){
  echo -e "\n\n"$1 $2;
  curl -X $1 localhost:4567$2;
}

function request_body(){
  echo -e "\n\n"$1 $2 $3;
  curl -X $1 localhost:4567$2 -d $3;
}

request GET    /hello/test_api.sh
request GET    /cart
request GET    /cart?limit=5\&order=asc
request GET    /cart?limit=3\&order=des
request GET    /cart/product/4
request POST   /cart/3
request PATCH  /cart/2
request PUT    /cart/1
request DELETE /cart/0
request GET    /cart
request GET    /cart/total

##request_body PUT /upload "{"code": "p 42"}"
#code=$(cat model.rb)
#curl -X PUT localhost:4567/upload -d "{'code':'${code}'}"

