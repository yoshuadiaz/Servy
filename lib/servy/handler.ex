defmodule Servy.Handler do
  @moduledoc "Handle HTTP request"
  alias Servy.Conv
  require Logger
  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1, emojify: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  

  @doc """
  Transforms the request into a response
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  # name=ElCacas&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    %{ conv | status: 201,
              resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!" }
  end

  def route(%Conv{method: "GET",path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET",path: "/bears"} = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Boboo, Baloo" }
  end

  def route(%Conv{method: "GET",path: "/bears/new"} = conv) do
    Path.expand("../../pages/", __DIR__)
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET",path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}; Si quieres te regalamos a Boboo (pero si lo elegiste te lo vendemos)." }
  end

  def route(%Conv{method: "DELETE",path: "/bears/" <> id} = conv) do
    %{ conv | status: 403, resp_body: "Dice bear-#{id} que no lo toques, anda chido" }
  end

  def route(%Conv{method: "GET",path: "/about" <> id} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET",path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file<>".html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{path: path } = conv) do
    Logger.error "Not exists"
    %{ conv | status: 404, resp_body: "No etsiste #{path}, Te kieres morir eze?" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}
    
    #{conv.resp_body}
    """
  end

  
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears/300 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
DELETE /bears/69 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bigdick HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /pages/santo_ninio_de HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=ElWuawuaras&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response