defmodule Tide.Tester do
  require Logger
  def run do
    Logger.info("Creating Repository")

    repo = %Tide.Repository{name: "tide-ci", path: "~/tide/tide-ci", uri: "git@github.com:drowzy/tide-ci.git"}

    Logger.info("Ensuring repo exists...")

    {:ok, _} = Tide.Repository.ensure(repo)

    uri = Tide.Docker.Client.default_uri

    Logger.info("Creating Tar-stream")

    {:ok, stream} = Tide.Repository.archive(repo)

    Logger.info("Ready to stream... Starting reciever")

    {:ok, producer_pid} = Tide.Reciever.start_link(job_id: :job_test, uri: uri, tar_stream: stream)
    {:ok, consumer_pid} = Tide.Consumer.start_link()

    GenStage.sync_subscribe(consumer_pid, to: producer_pid)
  end
end
