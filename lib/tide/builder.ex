defmodule Tide.Buidler do
  require Logger

  def run do
    Logger.info("Creating Repository")

    repo = %Tide.Repository{
      name: "tide-ci",
      path: "~/tide/tide-ci",
      uri: "git@github.com:drowzy/tide-ci.git"
    }
    uri = Tide.Docker.Client.default_uri()

    Logger.info("Ensuring repo exists...")
    Logger.info("Creating Tar-stream")

    {:ok, pid} = Tide.Build.start_link(repo: repo, uri: uri)

    Logger.info("Ready to stream... Starting reciever")

    {:ok, stream} = Tide.Build.status(pid)
    stream |> Enum.each(fn msg ->
      Logger.info("chunk1: #{inspect msg}")
    end)
  end
end
