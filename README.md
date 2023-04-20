# mux [![.github/workflows/ci.yml](https://github.com/threez/mux.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/threez/mux.cr/actions/workflows/ci.yml) [![https://threez.github.io/mux.cr/](https://badgen.net/badge/api/documentation/green)](https://threez.github.io/mux.cr/)

A simple http router for crystal. No fancy methods just a simple
frontend for `luislavena/radix`.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mux:
       github: threez/mux
   ```

2. Run `shards install`

## Usage

```crystal
require "mux"

mux = Mux::Router.new

mux.get "/foo/:id" do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello bar, got #{context.request.path} .. #{context.request.path_param[:id]}!"
end

mux.post "/" do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world, got #{context.request.path}!"
end

server = HTTP::Server.new(mux)

puts "Listening on http://127.0.0.1:8080"
server.listen(8080)
```

## Handler Class

Adding a regular handler (not HandlerProc) can be done the same way:

```crystal
class Foo
  include HTTP::Handler

  def call(context)
    context.response.content_type = "text/plain"
    context.response.print "Hello foo, got #{context.request.path}!"
  end
end

# using add handler for all methods
mux.add_handler("/all/*", Foo.new)

# or ...
mux.post "/all/*", Foo.new
```

## Contributing

1. Fork it (<https://github.com/threez/mux/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Vincent Landgraf](https://github.com/threez) - creator and maintainer
