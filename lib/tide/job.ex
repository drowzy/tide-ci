defmodule Tide.Job do
  alias Tide.Repository, as: Repo
  alias Tide.Schemas.Job

  @repo_dir Application.get_env(:tide_ci, :repo_dir)
  @socket_dir Application.get_env(:tide_ci, :socket_dir)

  @doc """
  """
  def start(repo_uri, host) do
    name = name_from_uri(repo_uri)
    repo = %Repo{name: name, path: tmp_dir(name), uri: repo_uri}

    case Job.create_job(%{status: "pending"}) do
      {:ok, %Job{id: id}} ->
        Tide.Job.Supervisor.start_job(id, via_tuple(id), repo: repo, uri: socket_uri(host))

      {:error, reason} ->
        {:error, reason}
    end
  end

  def progress(pid) when is_pid(pid), do: Tide.Job.Worker.status(pid)

  def progress(name) do
    name
    |> via_tuple()
    |> Tide.Job.Worker.status()
  end

  defp via_tuple(job_id) do
    {:via, Registry, {Job.Registry, job_id}}
  end

  defp socket_uri(path) do
    full_path = "#{@socket_dir}/#{path}.sock"

    "http+unix://#{URI.encode_www_form(full_path)}"
  end

  defp tmp_dir(name), do: "#{@repo_dir}/#{name}"

  def name_from_uri(uri) do
    uri
    |> Path.basename()
    |> String.split(".")
    |> List.first()
  end
end
