defmodule Tide.Repository do
  @moduledoc """
  """

  defstruct name: nil,
            type: :ssh,
            uri: nil,
            commit_ish: "master",
            path: nil

  @type git_type :: :ssh | :https
  @type t :: %__MODULE__{
          name: String.t(),
          type: git_type,
          uri: String.t(),
          commit_ish: String.t(),
          path: String.t()
        }

  @archive_format "tar.gz"

  @doc """
  Ensures that the repository exists on the filesystem.
  This is sort of a clone, if the directory is not empty
  """
  @spec ensure(Tide.Repository.t()) :: {:ok, Tide.Repository.t()} | {:error, String.t()}
  def ensure(%__MODULE__{commit_ish: branch} = git) do
    case clone_or_new(git) do
      {:ok, repo} -> Git.pull(repo, ["--rebase", "origin", branch])
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Creates an archive, and outputs a stream of the repository
  """
  def archive(%__MODULE__{name: name, commit_ish: commit, path: path} = repo, opts \\ []) do
    format = Keyword.get(opts, :format, @archive_format)
    output = "#{name}-#{commit}.#{format}"

    with {:ok, git_repo} <- clone_or_new(repo),
         {:ok, _} <-
           Git.archive(git_repo, [
             "--output=#{output}",
             "--format=#{format}",
             commit
           ]) do
      location =
        path
        |> Path.expand()
        |> Path.join(output)

      {:ok, File.stream!(location, [], 2048)}
    else
      {:error, reason} -> {:error, reason}
    end
  end
  @doc """
  archive bang version
  """
  def archive!(%__MODULE__{} = repo, opts \\ []) do
    case archive(repo, opts) do
      {:ok, stream} -> stream
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Checks if the remote repo is accessible
  """
  @spec accessable?(Tide.Repository.t()) :: boolean
  def accessable?(%__MODULE__{uri: uri, type: :ssh}) do
    case Git.ls_remote(nil, [uri]) do
      {:ok, _} -> true
      {:error, _reason} -> false
    end
  end

  defp clone_or_new(%__MODULE__{path: path, uri: uri}) do
    path = Path.expand(path)

    if File.exists?(path) do
      {:ok, Git.new(path)}
    else
      Git.clone([uri, path])
    end
  end

  @doc """
  Removes the directory
  """
  @spec clean(Tide.Repository.t()) :: {:ok, any()} | {:error, String.t()}
  def clean(%__MODULE__{} = attrs) do
  end
end
