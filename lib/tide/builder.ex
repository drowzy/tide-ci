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

    {:ok, pid} = Tide.Job.Supervisor.start_job(repo: repo, uri: uri)

    Logger.info("Ready to stream... Starting reciever")
  end
end
