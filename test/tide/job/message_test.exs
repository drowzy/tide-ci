defmodule Tide.Job.MessageTest do
  use ExUnit.Case

  alias Tide.Job.Message

  @aux %{"aux" => %{"ID" => "sha256:50dd4e092455f5eee053cc3549f80d467b41379b8b4e00d12b561001f28b20e9"}}
  @stream %{"stream" => " ---> 50dd4e092455\n"}
  @stream_list [
    %{"stream" => "Step 4/4 : RUN apt-get -y install vim git"},
    %{"stream" => "Step 3/4 : RUN apt-get update\n"},
    %{"stream" => "Step 2/4 : RUN mkdir demo\n"},
    %{"stream" => "Step 1/4 : FROM ubuntu:14.04"}
  ]

  test "#stringify `aux` message" do
    assert "ID : " <> Kernel.get_in(@aux, ["aux", "ID"]) == Message.stringify(@aux)
  end

  test "#stringify `stream` message" do
    assert @stream["stream"] == Message.stringify(@stream)
  end

  test "#stringify unknown message" do
    assert "unknown" == Message.stringify(%{"unknown" => "unknown"})
  end

  test "#stringify empty list" do
    assert "" == Message.stringify([])
  end

  test "#stringify list" do
    expected = @stream_list
    |> Enum.map(&(Map.get(&1, "stream")))
    |> Enum.reverse
    |> Enum.join("")

    assert expected == Message.stringify(@stream_list)
  end
end
