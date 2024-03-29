defmodule Tide.Docker.Client do
  @moduledoc """
  Docker client
  """
  @version "v1.29"
  @uri "http+unix://#{URI.encode_www_form("/var/run/docker.sock")}/#{@version}"
  @timeout 50_000
  def default_uri, do: @uri

  def build(uri, tar_stream, opts \\ []) do
    base_url = uri <> "/build"
    headers = %{"content-type" => "application/x-tar", "accept" => "application/json"}

    HTTPoison.post(
      base_url,
      {:stream, tar_stream},
      headers,
      Keyword.merge(opts, recv_timeout: @timeout)
    )
  end
end
