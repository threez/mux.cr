require "spec"
require "../src/mux"

def test_request(mux, method, path)
  io = IO::Memory.new
  request = HTTP::Request.new(method, path)
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)

  mux.call(context)
  response.close
  io.to_s
end
