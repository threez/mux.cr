require "./spec_helper"

class Foo
  include HTTP::Handler

  def call(context)
    context.response.content_type = "text/plain"
    context.response.print "Hello foo!"
  end
end

describe Mux do
  it "returns not found with no handler" do
    mux = Mux::Router.new

    body = test_request(mux, "GET", "/")
    body.should eq "HTTP/1.1 404 Not Found\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: 14\r\n" +
                   "\r\n" +
                   "404 Not Found\n"
  end

  it "can add a handler class" do
    mux = Mux::Router.new
    mux.add_handler("/foo", Foo.new)

    body = test_request(mux, "GET", "/foo")
    body.should eq "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: 10\r\n" +
                   "\r\n" +
                   "Hello foo!"
  end

  it "can handle procs with parameters" do
    mux = Mux::Router.new
    mux.add_handler("/foo/:id") do |context|
      context.response.content_type = "text/plain"
      context.response.print "Hello bar, got #{context.request.path} .. #{context.request.path_param(:id)}!"

      context.request.path_param(:id).should eq "123"
      context.request.path_param?(:foo).should eq nil
    end

    body = test_request(mux, "GET", "/foo/123")
    body.should eq "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: 31\r\n" +
                   "\r\n" +
                   "Hello bar, got /foo/123 .. 123!"
  end

  it "can handle method restrictions" do
    mux = Mux::Router.new
    mux.post "/" do |context|
      context.response.print "Hello"
    end

    # not working
    body = test_request(mux, "GET", "/")
    body.should eq "HTTP/1.1 404 Not Found\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: 14\r\n" +
                   "\r\n" +
                   "404 Not Found\n"

    #  working
    body = test_request(mux, "POST", "/")
    body.should eq "HTTP/1.1 200 OK\r\n" +
                   "Content-Length: 5\r\n" +
                   "\r\n" +
                   "Hello"
  end
end
