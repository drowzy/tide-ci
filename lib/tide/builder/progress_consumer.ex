defmodule Tide.Builder.ProgressConsumer do
  require Logger
  use GenStage

  def start_link do
    Logger.info("starting consumer")
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok), do: {:consumer, nil}

  def handle_events(events, _from, state) do
    Logger.info("Received #{length(events)} from producer: #{inspect(events)}")
    {:noreply, [], state}
  end

  def handle_info({_, :stop}, state) do
    Logger.info("STOPPING CONSUMER")
    {:stop, :normal, state}
  end
end
