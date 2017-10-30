defmodule Tide.Hosts.SSH do
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

    # ssh = Tide.Hosts.SSH("192.168.90.15", "ubuntu", password: "26ff15b70e7b6c7a7f037b87")
    case :ssh.connect(String.to_charlist(host), port, config) do
      {:ok, conn} -> {:ok, %__MODULE__{host: host, user: user, port: port, password: pass, conn: conn}}
      {:error, reason} -> {:error, reason}
    end
  end

  def disconnect(%__MODULE__{conn: conn}), do: :ssh.close(conn)

  def channel(%__MODULE__{conn: conn}), do: :ssh_connection.session_channel(conn, 5000)

  def close_channel(%__MODULE__{conn: conn}, ch), do: :ssh_connection.close(conn, ch)

end
