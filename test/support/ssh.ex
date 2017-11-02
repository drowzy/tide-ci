defmodule Tide.TestSupport.SSH do
    def connect(host, port, config) do
      {:ok, Kernel.make_ref()}
    end

    def open_channel(_conn, _type, _msg, _max_win, _max_pack, _timeout) do
      {:open, 0}
    end

    def close(_conn) do
      :ok
    end

    def session_channel(_conn, _timeout) do
      {:open, 0}
    end

    def close_channel(_conn, _ch) do
      :ok
    end
  end
end
