defmodule Tide.Hosts.SSH do
  @ini_window_size 1 * 1024 * 1024
  @max_packet_size 32 * 1024
  @timeout :infinity

  defstruct [ host: nil, user: nil, port: nil, password: nil, conn: nil ]

  @type t :: %__MODULE__{
    host: String.t,
    user: String.t,
    password: String.t,
    port: integer,
    conn: term
  }

  def connect(host, user, opts \\ []) do
    pass = Keyword.get(opts, :password, nil)
    port = Keyword.get(opts, :port, 22)
    config = [
      user_interaction: false,
      silently_accept_hosts: true,
      user: String.to_charlist(user),
      password: String.to_charlist(pass)
    ]
    # {:ok, ssh } = Tide.Hosts.SSH.connect("192.168.90.15", "ubuntu", password: "26ff15b70e7b6c7a7f037b87")
    case :ssh.connect(String.to_charlist(host), port, config) do
      {:ok, conn} -> {:ok, %__MODULE__{host: host, user: user, port: port, password: pass, conn: conn}}
      {:error, reason} -> {:error, reason}
    end
  end

  #
  def stream_local_forward(%__MODULE__{conn: conn}, socket_path) do
    type = String.to_charlist("direct-streamlocal@openssh.com")
    msg = << byte_size(socket_path) :: size(32), socket_path :: binary, 0 :: size(32), 0 :: size(32) >>

    :ssh_connection_handler.open_channel(conn, type, msg, @ini_window_size, @max_packet_size, 5000)
  end

  def direct_tcpip(%__MODULE__{conn: conn}, remote_host, remote_port, orig_host, orig_port) do
    type = String.to_charlist("direct-tcpip")
    host_len = byte_size(remote_host)
    orig_len = byte_size(orig_host)
    msg = <<host_len :: size(32), remote_host :: binary, remote_port :: size(32), orig_len :: size(32), orig_host :: binary, orig_port :: size(32) >>

    :ssh_connection_handler.open_channel(conn, type , msg, @ini_window_size, @max_packet_size, 5000)
  end

  def disconnect(%__MODULE__{conn: conn}), do: :ssh.close(conn)
  def session(%__MODULE__{conn: conn}), do: :ssh_connection.session_channel(conn, 5000)
  def close_channel(%__MODULE__{conn: conn}, ch), do: :ssh_connection.close(conn, ch)

end
