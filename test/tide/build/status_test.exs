defmodule Tide.Build.StatusTest do
  use ExUnit.Case

  alias Tide.Build.Status

  setup do
    state = %{chunks: [], pending_demand: 0, status: :pending}
    {:ok, %{state: state}}
  end

  test "Status should handle AsyncChunk", %{state: state} do
    chunk = "{\"stream\": \"Step 1/4 : FROM ubuntu:14.04\n\"}"

    {:noreply, [], %{chunks: chunks}} =
      Status.handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state)

    assert List.first(chunks) == Poison.decode!(chunk)
  end

  test "Status sets status processing after receiveing a chunk", %{state: state} do
    chunk = "{\"stream\": \"Step 1/4 : FROM ubuntu:14.04\n\"}"

    {:noreply, [], %{status: status}} =
      Status.handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state)

    assert status == :processing
  end

  test "Status sets status to :started when receiving AsyncHeaders", %{state: state} do
    {:noreply, [], %{status: status}} =
      Status.handle_info(
        %HTTPoison.AsyncHeaders{headers: [{"accept", "application/json"}]},
        state
      )

    assert status == :started
  end

  test "Status should handle AsyncStatus with success", %{state: state} do
    assert {:noreply, [], ^state} = Status.handle_info(%HTTPoison.AsyncStatus{code: 200}, state)
  end

  test "Status should stop if code is anything but 200", %{state: state} do
    assert {:stop, {:error, code}, state} =
             Status.handle_info(%HTTPoison.AsyncStatus{code: 404}, state)

    assert code == 404
  end

  test "Status should set status = done when end of stream", %{state: state} do
    {:noreply, [], %{status: status}} = Status.handle_info(%HTTPoison.AsyncEnd{}, state)
    assert status == :done
  end

  test "Status should handle :stop sent to info", %{state: state} do
    assert {:stop, :normal, ^state} = Status.handle_info(:stop, state)
  end
end
