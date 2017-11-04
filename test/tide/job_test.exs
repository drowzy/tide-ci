defmodule Tide.JobTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, producer} = GenStage.from_enumerable(["foo", "bar"])

    state = %{
      status: :pending,
      status_stream: producer,
      log: []
    }

    chunk = {:chunk, %{"stream" => "Step 1/4 : FROM ubuntu:14.04"}}
    {:ok, %{state: state, chunk: chunk}}
  end

  test "Can receive a log stream", %{state: state} do
    assert {:reply, {:ok, stream}, _} = Tide.Job.handle_call(:log, self(), state)
    assert ["foo", "bar"] == Enum.take(stream, 2)
  end

  test "handle_events with chunk sets status to building", %{state: state, chunk: chunk} do
    {:noreply, [], new_state} = Tide.Job.handle_events([chunk], self(), state)

    assert new_state.status == :building
  end

  test "handle_events with chunk adds the chunk to the log", %{state: state, chunk: chunk} do
    {:noreply, [], new_state} = Tide.Job.handle_events([chunk], self(), state)

    assert length(new_state.log) == 1
  end

  test "handle_events with status_code not 200 marks the job as a failure", %{state: state} do
    {:noreply, [], new_state} = Tide.Job.handle_events([{:status, 400}], self(), state)

    assert new_state.status == :failed
  end

  test "handle_events with status_code 200 marks the job as a started", %{state: state} do
    {:noreply, [], new_state} = Tide.Job.handle_events([{:status, 200}], self(), state)

    assert new_state.status == :started
  end

  test "handles stop message", %{state: state} do
    {:stop, :normal, ^state} = Tide.Job.handle_info({:ok, :stop}, state)
  end
end
