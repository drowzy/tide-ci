defmodule TideWeb.EventController do
  use TideWeb, :controller
  require Logger

  def handler(conn, params) do
    Logger.info("Recevied Event params: #{inspect params}")

    conn
    |> put_status(:ok)
    |> json(%{})
  end
end
