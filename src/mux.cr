require "http/server/handler"
require "./http_request"

require "radix"

# Mux provides a simple no magic `Router`.
#
#     require "mux"
#
#     mux = Mux::Router.new
#     mux.post "/hello/:world" do |context|
#       context.response.print "Hello #{context.request.path_param(:world)}"
#     end
#
#     server = HTTP::Server.new(mux)
#     server.listen(8080)
#
# The implementation is based on the `luislavena/radix` shard.
module Mux
  VERSION = "0.1.0"

  # The router usually passed as an argument to `HTTP::Server.new`.
  class Router
    include HTTP::Handler

    # the placehoder for all methods
    ALL_METHODS = :all

    # create a new router with no routes.
    def initialize
      @tree = Radix::Tree(HandlerProc | HTTP::Handler).new
    end

    # add handler using and optionally specify the method
    #
    # * `path` the path to register the handler under
    # * `handler` the handler to register at the given path
    # * `method` the method to filter for, if `ALL_METHODS`
    #   is used, no restrictions are made and all methods
    #   will trigger the handler.
    def add_handler(path : String,
                    handler : HTTP::Handler, *,
                    method : (String | Symbol) = ALL_METHODS)
      @tree.add(lookup(method, path), handler)
    end

    # add handler using and optionally specify the method
    #
    # * `path` the path to register the handler under
    # * `handler` the handler to register at the given path
    # * `method` the method to filter for, if `ALL_METHODS`
    #   is used, no restrictions are made and all methods
    #   will trigger the handler.
    def add_handler(path : String, *,
                    method : (String | Symbol) = ALL_METHODS,
                    &handler : HandlerProc)
      @tree.add(lookup(method, path), handler)
    end

    {% for method in ["get", "head", "post", "put", "delete", "connect", "options", "trace", "patch"] %}
      # add HTTP {{method.id}} handler using a hanlder class
      #
      # * `path` the path to register the handler under
      # * `handler` the handler to register at the given path
      def {{method.id}}(path, handler : HTTP::Handler)
        add_handler(path, handler, method: {{method}})
      end

      # add HTTP {{method.id}} handler using a handler proc
      #
      # * `path` the path to register the handler under
      # * `handler` the handler to register at the given path
      def {{method.id}}(path, &handler : HandlerProc)
      add_handler(path, method: {{method}}, &handler)
      end
    {% end %}

    # implementes HTTP::Handler
    def call(context)
      result = @tree.find(lookup(context.request.method, context.request.path))
      if !result.found?
        result = @tree.find(lookup(ALL_METHODS, context.request.path))
      end

      if result.found?
        handler = result.payload
        context.request.path_params = result.params
        handler.call(context)
      else
        call_next(context)
      end
    end

    # convert method and path for radix tree
    private def lookup(method : (String | Symbol), path)
      "/#{method.to_s.downcase}#{path}"
    end
  end
end
