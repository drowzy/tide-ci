defmodule Tide.Builder.ProducerTest do
  use ExUnit.Case

  alias Tide.Builder.Producer

  setup do
    state = %{chunks: [], pending_demand: 0, status: :pending}
    {:ok, %{state: state}}
  end

  test "Producer should handle AsyncChunk", %{state: state} do
    chunk = "{\"stream\": \"Step 1/4 : FROM ubuntu:14.04\n\"}"
    {:noreply, [], %{chunks: chunks}} =
      Producer.handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state)

    assert List.first(chunks) == Poison.decode!(chunk)
  end

  test "Producer sets status processing after receiveing a chunk", %{state: state} do
    chunk = "{\"stream\": \"Step 1/4 : FROM ubuntu:14.04\n\"}"
    {:noreply, [], %{status: status}} =
      Producer.handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state)

    assert status == :processing
  end

  test "Producer sets status to :started when receiving AsyncHeaders", %{state: state} do
    {:noreply, [], %{status: status}} = Producer.handle_info(%HTTPoison.AsyncHeaders{headers: [{"accept", "application/json"}]}, state)

    assert status == :started
  end

  test "Producer should handle AsyncStatus with success", %{state: state} do
    assert {:noreply, [], ^state} = Producer.handle_info(%HTTPoison.AsyncStatus{code: 200}, state)
  end

  test "Producer should stop if code is anything but 200", %{state: state} do
    assert {:stop, {:error, code}, state} = Producer.handle_info(%HTTPoison.AsyncStatus{code: 404}, state)
    assert code == 404
  end

  test "Producer should stop when end of stream is reached" do
  end

end
