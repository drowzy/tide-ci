defmodule Tide.Hosts.SSH do
  defstruct [ host: nil, user: nil, port: nil, password: nil, conn: nil ]

  @type t :: %__MODULE__{
    host: String.t,
    user: String.t,
    password: String.t,
    port: integer,
    conn: term
  }

  def connect(%__MODULE__{host: host, port: port, user: user, password: pass}) do
    {:ok, conn} = :ssh.connect(String.to_char_list!(host), port,
      [
        user_interaction: false,
        user: String.to_char_list!(user),
        password: pass,
        silently_accept_hosts: true
      ]
    )
  end

end
