defmodule TideWeb.HostController do
  use TideWeb, :controller

  alias Tide.Schemas.Host

  plug(:find_host when action in [:show, :update, :delete, :connect, :disconnect])

  def index(conn, _params) do
    hosts = Host.list()

    conn
    |> put_status(:ok)
    |> json(hosts)
  end

  def create(conn, %{"user" => user} = params) do
    {status, entity} =
      with {:ok, %Host{id: id, hostname: hostname} = host} <- Host.create(params),
           {:ok, _pid} = Tide.Hosts.connect(hostname, user) do
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

  def connect(conn = %Plug.Conn{assigns: %{host: %{is_active: true} = host}}, %{"user" => user}) do
    resp =
      case Tide.Hosts.connected?(host.hostname) do
        true ->
          {:no_content, %{}}

        false ->
          {:ok, _pid} = Tide.Hosts.connect(host.hostname, user)
          {:ok, %{message: "Host #{host.hostname} connected"}}
      end

    respond(conn, resp)
  end

  def connect(conn = %Plug.Conn{assigns: %{host: host}}, %{"user" => user}) do
    case Tide.Hosts.connected?(host.hostname) do
      true ->
        :ok

      false ->
        {:ok, _pid} = Tide.Hosts.connect(host.hostname, user)
    end

    resp =
      case Host.update(host, %{is_active: true}) do
        {:ok, host} -> {:ok, %{message: "Host #{host.hostname} connected"}}
        {:error, %Ecto.Changeset{} = _change} -> {:internal_server_error, %{message: "rekt"}}
      end

    respond(conn, resp)
  end

  def update(conn, params) do
  end

  def delete(conn = %Plug.Conn{assigns: %{host: host}}, _params) do
    resp =
      with _reason <- Tide.Hosts.disconnect(host.hostname),
           {:ok, _changeset} <- Host.delete(host) do
        {:no_content, %{}}
      else
        {:error, _} -> {:internal_server_error, %{message: "rekt"}}
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
