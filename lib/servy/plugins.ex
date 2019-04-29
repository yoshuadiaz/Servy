defmodule Servy.Plugins do
  alias Servy.Conv
  
  def emojify(%Conv{status: 200} = conv) do
    response = "🤩🤩🤩🤩🤩 : " <> conv.resp_body
    %{conv | resp_body: response}
  end

  def emojify(%Conv{} = conv), do: conv

  @doc """
  Track 404 status
  """
  def track(%Conv{status: 404, path: path} =  conv) do
    IO.puts "404 in: #{path}"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(conv), do: IO.inspect conv
end