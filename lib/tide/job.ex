defmodule Tide.Job do
  alias Tide.Repository, as: Repo

  @repo_dir Application.get_env(:tide_ci, :repo_dir)
  @socket_dir Application.get_env(:tide_ci, :socket_dir)

  @doc """
  """
  def start(repo_uri, host) do
    name = name_from_uri(repo_uri)
    repo = %Repo{name: name, path: tmp_dir(name), uri: repo_uri}

    Tide.Job.Supervisor.start_job(repo: repo, uri: socket_uri(host))
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
