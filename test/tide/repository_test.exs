defmodule Auth.GrantTest do
  use ExUnit.Case

  alias Tide.Repository

  setup do
    Temp.track!
    dir = Temp.mkdir! "tide-repo"
    {:ok, %{dir: dir}}
  end

  test "#ensure clone", %{dir: dir} do
    repo = %Repository{
      path: Path.join(dir, "new-repo"),
      uri: File.cwd!,
    }

    assert {:ok, _repo} = Repository.ensure(repo)

    assert File.exists?(repo.path)
    assert File.exists?(Path.join(repo.path, ".git"))
    Temp.cleanup
  end

  test "#archive creates a tar.gz on the form name:commit-ish.tar.gz", %{dir: dir} do
    repo = %Repository{
      name: "archive",
      commit_ish: "master",
      path: Path.join(dir, "new-repo"),
      uri: File.cwd!,
    }

    archive_path = Path.join([repo.path, "#{repo.name}:#{repo.commit_ish}.tar.gz"])

    {:ok, _repo} = Repository.ensure(repo)
    {:ok, _stream} = Repository.archive(repo)
    assert File.exists?(archive_path)
    Temp.cleanup
  end

  test "#accessable returns repoistory access", %{dir: dir} do
    repo = %Repository{
      name: "archive",
      commit_ish: "master",
      path: Path.join(dir, "new-repo"),
      uri: File.cwd!,
    }

    assert Repository.accessable?(repo) == true
  end


end
