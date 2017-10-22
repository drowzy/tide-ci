defmodule Tide.Git do
  @moduledoc """
  """
  @type git_type :: (:ssh | :https)

  defstruct type: :ssh,
    uri: nil,
    default_branch: "master",
    path: nil

  @type t :: %__MODULE__{
    type: git_type,
    uri: String.t,
    default_branch: String.t,
    path: String.t,
  }

  @doc """
  Ensures that the repository exists on the filesystem.
  This is sort of a clone, if the directory is not empty
  """
  @spec ensure(Tide.Git.t) :: {:ok, Tide.Git.t} | {:error, String.t}
  def ensure(%__MODULE__{default_branch: branch} = git) do
    case clone_or_new(git) do
      {:ok, repo} -> Git.pull repo, ["--rebase", "origin", branch]
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Creates an archive, and outputs a stream of the repository
  """
  def archive(%__MODULE__{} = git, opts \\ []) do
    with {:ok, repo} <- clone_or_new(git),
         {:ok, _} <- Git.archive(repo, [
           "--output=test.tar.gz",
           "--format=tar.gz",
           "HEAD"
         ]) do
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Checks if the remote repo is accessible
  """
  @spec accessable?(Tide.Git.t) :: boolean
  def accessable?(%__MODULE__{uri: uri, type: :ssh}) do
    case Git.ls_remote(nil, [uri]) do
      {:ok, _} -> true
      {:error, _reason} -> false
    end
  end

  defp clone_or_new(%__MODULE__{path: path, uri: uri}) do
    path = Path.expand path

    if File.exists? path do
      {:ok, Git.new path}
    else
      Git.clone [uri, path]
    end
  end

  @doc """
  Removes the directory
  """
  @spec clean(Tide.Git.t) :: {:ok, any()} | {:error, String.t}
  def clean(%__MODULE__{} = attrs) do
  end

end
