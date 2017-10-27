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

    {:ok, _} = Tide.Repository.ensure(repo)
    {:ok, pid} = Tide.Build.start_link(repo: repo, uri: uri)

    Logger.info("Ready to stream... Starting reciever")

    {:ok, stream} = Tide.Build.status(pid)
    stream
    |> Stream.each(fn msg ->
      Logger.info("chunk: #{inspect msg}")
    end)
    |> Stream.run
  end
end
