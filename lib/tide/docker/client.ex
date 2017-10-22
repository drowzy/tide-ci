defmodule Tide.Docker.Client do
  @moduledoc """
  Docker client
  """
  use Tesla
  @version "v1.29"
  @uri "http+unix://#{URI.encode_www_form("/var/run/docker.sock")}/#{@version}"

  plug Tesla.Middleware.BaseUrl, @uri

  def new(headers \\ %{}) do
    Tesla.build_client [
      {Tesla.Middleware.Headers,
       %{
         "content-type" => "application/tar",
         "accept" => "application/json"
       }
      }
    ]
  end

  def build(client, tar_stream) do
    post(client, "/build", tar_stream)
  end
end
