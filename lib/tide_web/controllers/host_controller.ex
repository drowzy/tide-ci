defmodule TideWeb.HostController do
  use TideWeb, :controller
  require Logger

  alias Tide.Schemas.Host

  plug(:find_host when action in [:show, :update, :delete, :connect, :disconnect])

  def index(conn, _params) do
    hosts = Host.list()

    conn
    |> put_status(:ok)
    |> json(hosts)
  end

  def create(conn, params) do
    {status, entity} =
      with {:ok, %Host{id: id, hostname: hostname, credentials: credentials} = host} <- Host.create(params),
           {:ok, _pid} = Tide.Hosts.connect(id, hostname, credentials.user) do
        {:created, host}
      else
        _ -> {:unprocessable_entity, %{error: "failed"}}
      end

    conn
    |> put_status(status)
    |> json(entity)
  end

  def show(conn, %{"id" => id}) do
    resp =
      case Host.get!(id) do
        %Host{} = host -> {:ok, host}
        nil -> {:not_found, %{message: "Host with #{id} not found"}}
      end

    respond(conn, resp)
  end

  def connect(conn = %Plug.Conn{assigns: %{host: %{is_active: true} = host}}, _params) do
    resp =
      case Tide.Hosts.connected?(host.hostname) do
        true ->
          {:no_content, %{}}

        false ->
          {:ok, _pid} = Tide.Hosts.connect(host.id, host.hostname, host.credentials.user)
          {:ok, %{message: "Host #{host.hostname} connected"}}
      end

    respond(conn, resp)
  end

  def connect(conn = %Plug.Conn{assigns: %{host: host}}, _params) do
    case Tide.Hosts.connected?(host.hostname) do
      true ->
        :ok

      false ->
        {:ok, _pid} = Tide.Hosts.connect(host.id, host.hostname, host.credentials.user)
    end

    resp =
      case Host.update(host, %{is_active: true}) do
        {:ok, host} -> {:ok, %{message: "Host #{host.hostname} connected"}}
        {:error, %Ecto.Changeset{} = _change} -> {:internal_server_error, %{message: "rekt"}}
      end

    respond(conn, resp)
  end

  def update(_conn, _params) do
  end

  def delete(conn = %Plug.Conn{assigns: %{host: host}}, _params) do
    resp =
      with _reason <- Tide.Hosts.disconnect(host.id),
           {:ok, _changeset} <- Host.delete(host) do
        Logger.info("Host #{host.hostname} disconnected & deleted")
        {:no_content, %{}}
      else
        {:error, reason} ->
          Logger.error("Host #{host.hostname} could not be disconnedted #{inspect reason}")
          {:internal_server_error, %{message: "rekt"}}
      end

    respond(conn, resp)
  end

  defp find_host(conn = %Plug.Conn{params: params}, _opts) do
    id = Map.get(params, "id") || Map.get(params, "host_id")

    case Host.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "resource #{id} not found"})
        |> halt()

      host ->
        assign(conn, :host, host)
    end
  end

  defp respond(conn, {status, resp}) do
    conn
    |> put_status(status)
    |> json(resp)
  end
end
