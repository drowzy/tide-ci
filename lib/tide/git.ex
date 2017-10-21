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
  def ensure do
  end

  @doc """
  Creates an archive stream of the repository
  """
  def archive do
  end

  @doc """
  Checks if the remote repo is accessible
  """
  @spec accessable?(Tide.Git.t) :: boolean
  def accessable?(%__MODULE__{path: path, type: :ssh}) do
    case Git.ls_remote do
      {:ok, _} -> true
      {:error, _reason} -> false
    end
  end

  defp dirname(%__MODULE__{}) do
  end

end
