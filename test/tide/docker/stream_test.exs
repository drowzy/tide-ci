defmodule Tide.Docker.StreamTest do
  use ExUnit.Case

  alias Tide.Docker.Stream

  setup do
    state = %{chunks: [], demand: 0}
    {:ok, %{state: state}}
  end

  test "data chunks should be returned as :chunk chunk", %{state: state} do
    chunk = "{\"stream\": \"Step 1/4 : FROM ubuntu:14.04\n\"}"

    {:noreply, [], %{chunks: chunks}} =
      Stream.handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state)

    {:chunk, res} = List.first(chunks)

    assert res == Poison.decode!(chunk)
  end

  test "should returns http headers as a :header chunk", %{state: state} do
    assert {:noreply, [{:headers, headers}], _} =
             Stream.handle_info(
               %HTTPoison.AsyncHeaders{headers: [{"accept", "application/json"}]},
               state
             )
  end

  test "should return status code as a :status chunk", %{state: state} do
    assert {:noreply, [{:status, code}], ^state} =
             Stream.handle_info(%HTTPoison.AsyncStatus{code: 200}, state)

    assert code == 200
  end

  test "should return status code chunk no matter if success or failure", %{state: state} do
    assert {:noreply, [{:status, code}], state} =
             Stream.handle_info(%HTTPoison.AsyncStatus{code: 404}, state)

    assert code == 404
  end

  test "Stream should handle :stop sent to info", %{state: state} do
    assert {:stop, :normal, ^state} = Stream.handle_info(:stop, state)
  end
end
