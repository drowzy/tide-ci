defmodule Tide.Hosts.SSH do
  @ini_window_size 1 * 1024 * 1024
  @max_packet_size 32 * 1024
  @timeout :infinity

  defstruct host: nil, user: nil, port: nil, password: nil, conn: nil

  @type t :: %__MODULE__{
          host: String.t(),
          user: String.t(),
          port: integer,
          conn: term
        }

  def connect(host, user, opts \\ []) do
    port = Keyword.get(opts, :port, 22)
    ssh = Keyword.get(opts, :ssh_module, :ssh)
    key_cb = Keyword.get(opts, :key_cb, default_ssh_module())

    config = [
      user_interaction: false,
      silently_accept_hosts: true,
      user: String.to_charlist(user),
      key_cb: key_cb
    ]

    case ssh.connect(String.to_charlist(host), port, config) do
      {:ok, conn} ->
        {:ok, %__MODULE__{host: host, user: user, port: port, conn: conn}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  #
  def stream_local_forward(%__MODULE__{conn: conn}, socket_path, opts \\ []) do
    ssh = Keyword.get(opts, :ssh_module, :ssh_connection_handler)
    type = String.to_charlist("direct-streamlocal@openssh.com")
    msg = <<byte_size(socket_path)::size(32), socket_path::binary, 0::size(32), 0::size(32)>>

    ssh.open_channel(conn, type, msg, @ini_window_size, @max_packet_size, 5000)
  end

  def direct_tcpip(
        %__MODULE__{conn: conn},
        remote_host,
        remote_port,
        orig_host,
        orig_port,
        opts \\ []
      ) do
    ssh = Keyword.get(opts, :ssh_module, :ssh_connection_handler)

    type = String.to_charlist("direct-tcpip")
    host_len = byte_size(remote_host)
    orig_len = byte_size(orig_host)

    msg = <<
      host_len::size(32),
      remote_host::binary,
      remote_port::size(32),
      orig_len::size(32),
      orig_host::binary,
      orig_port::size(32)
    >>

    ssh.open_channel(conn, type, msg, @ini_window_size, @max_packet_size, 5000)
  end

  def disconnect(%__MODULE__{conn: conn}, opts \\ []) do
    ssh = Keyword.get(opts, :ssh_module, :ssh)
    ssh.close(conn)
  end

  def session(%__MODULE__{conn: conn}, opts \\ []) do
    ssh = Keyword.get(opts, :ssh_module, :ssh_connection)
    ssh.session_channel(conn, 5000)
  end

  def close_channel(%__MODULE__{conn: conn}, ch, opts \\ []) do
    ssh = Keyword.get(opts, :ssh_module, :ssh_connection)
    ssh.close(conn, ch)
  end

  defp default_ssh_module do
    ssh_dir = Path.expand("~/.ssh")

    SSHClientKeyAPI.with_options(
      identity: File.open!(Path.join(ssh_dir, "id_rsa")),
      known_hosts: File.open!(Path.join(ssh_dir, "id_rsa"))
    )
  end
end
