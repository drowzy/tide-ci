defmodule Tide.Docker.Client do
  @moduledoc """
  Docker client
  """
  @version "v1.29"
  @uri "http+unix://#{URI.encode_www_form("/var/run/docker.sock")}/#{@version}"

  def build(uri, tar_stream), do: do_build(uri, tar_stream)
  def build(tar_stream), do: do_build(@uri, tar_stream)

  defp do_build(uri, tar_stream) do
    Tide.Docker.HTTP.stream(uri, "/build", tar_stream)
  end

end
