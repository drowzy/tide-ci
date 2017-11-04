defmodule Tide.SSHTest do
  use ExUnit.Case, async: true
  alias Tide.Hosts.SSH

  setup do
    {:ok, conn} = SSH.connect("192.168.1.1", "foo", password: "foobar", ssh_module: SSHMock)

    {
      :ok,
      %{
        conn: conn,
        ssh_module: SSHMock
      }
    }
  end

  test "returns a connection if connect is successfull", %{conn: conn} do
    assert %SSH{} = conn
  end

  test "can open a streamlocal channel", %{conn: conn, ssh_module: ssh} do
    assert {:open, ch} = SSH.stream_local_forward(conn, "/var/run/socket.sock", ssh_module: ssh)
    assert Kernel.is_number(ch)
  end

  test "can open a direct-tcpip channel", %{conn: conn, ssh_module: ssh} do
    assert {:open, ch} =
             SSH.direct_tcpip(conn, "192.168.1.1", 80, "192.168.1.2", 80, ssh_module: ssh)

    assert Kernel.is_number(ch)
  end

  test "disconnect returns :ok if sucessfull", %{conn: conn, ssh_module: ssh} do
    assert :ok = SSH.disconnect(conn, ssh_module: ssh)
  end

  test "closing the channel returns :ok when sucessfull", %{conn: conn, ssh_module: ssh} do
    assert :ok = SSH.close_channel(conn, 0, ssh_module: ssh)
  end
end
