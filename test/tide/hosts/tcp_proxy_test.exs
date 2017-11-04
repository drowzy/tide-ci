defmodule Tide.Hosts.TcpProxyTest do
  use ExUnit.Case

  setup do
    Temp.track!()
    dir = Temp.mkdir!("tide-repo")
    path = Path.join(dir, "/test.sock")

    {:ok, ls} = Tide.Hosts.TcpProxy.listen(path)
    {:ok, %{dir: dir, ls: ls, path: path}}
  end

  test "creates a local socket at the provided path", %{dir: path} do
    assert File.exists?(path)
  end

  test "can close listening socket", %{ls: ls} do
    assert :ok = Tide.Hosts.TcpProxy.close(ls)
  end

  test "runs the callback with data from the socket", %{path: path, ls: ls, path: path} do
    pid = self()
    callback = &send(pid, {:msg, &1})

    Task.start(fn ->
      Tide.Hosts.TcpProxy.accept(ls, callback)
    end)

    {:ok, sock} = :gen_tcp.connect({:local, path}, 0, [:binary, active: false, packet: 4])
    :gen_tcp.send(sock, "foo\n")

    assert_receive {:msg, _data}, 5000
  end
end
