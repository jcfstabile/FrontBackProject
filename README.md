### Install sinatra

install the gems

```
gem install sinatra
gem install puma
```

### Try it

1. on *backend.rb*

```
require 'sinatra'

get '/' do
  'Hola you'
end
```


2. run (once) with

```
$ . ./up.sh
```


3. keep server running

```
$ . ./backend_up.sh
```
view at http://localhost:4567
