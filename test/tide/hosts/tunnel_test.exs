defmodule Tide.Hosts.TunnelTest do
  use ExUnit.Case, async: false

  setup do
    state = %{
      ls: nil,
      channel: 0,
      ssh: nil,
      client: nil
    }
    {:ok, %{state: state}}
  end

  test "handle_info tcp_client adds the client to the state", %{state: state} do
    ref = Kernel.make_ref()

    assert {:noreply, new_state} = Tide.Hosts.SSH.Tunnel.handle_info({:tcp_client, ref}, state)
    assert ref == new_state.client
  end
  # setup do
  #   Temp.track!()
  #   dir = Temp.mkdir!("hosts")
  #   hostname = "test-host"

  #   {:ok, ssh} = SSH.connect(hostname, "user", ssh_module: SSHMock)
  #   {:ok, server} = Tide.Hosts.SSH.Tunnel.start_link(ssh, socket_dir: dir)
  #   {:ok, %{server: server, path: Path.join(dir, "/#{hostname}.sock")}}
  # end

  # test "get_host returns the hostname of the forwarded host", %{server: server} do
  #   assert "test-host" == Tide.Hosts.SSH.Tunnel.get_host(server)
  # end

  # test "ssh messages are forwared to tcp clients" , %{server: server, path: path} do
  #   {:ok, sock} = :gen_tcp.connect({:local, path}, 0, [:binary, active: false, packet: 4])
  #   send(server, {:ssh_cm, :ok, {:data, 1, :ok, "foo\n"}})

  #   assert {:ok, msg} = :gen_tcp.recv(sock, 0)
  #   assert msg == "foo\n"
  # end
end
