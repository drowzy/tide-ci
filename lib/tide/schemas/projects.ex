defmodule Tide.Schemas.Project do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Tide.Repo
  alias Tide.Schemas.Project

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Poison.Encoder, only: [:id, :owner, :name, :description, :slug, :vcs_url]}

  schema "projects" do
    field(:name, :string)
    field(:slug, :string)
    field(:owner, :string)
    field(:vcs_url, :string)
    field(:description, :string)
    has_many(:jobs, Tide.Schemas.Job)

    timestamps()
  end

  @fields ~w(name owner vcs_url description)

  def insert_changeset(data, params \\ %{}) do
    case common_changeset(data, params) do
      %Ecto.Changeset{changes: %{name: name, owner: owner}} = project ->
        slug = generate_slug(owner, name)
        put_change(project, :slug, slug)

      %Ecto.Changeset{errors: _errors} = change ->
        change
    end
  end

  def update_changeset(data, params \\ %{}) do
    common_changeset(data, params)
  end

  def common_changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:name, :vcs_url, :owner])
  end

  def list, do: Repo.all(Project)
  def get(id), do: Repo.get(Project, id)
  def get!(id), do: Repo.get!(Project, id)

  def create(attrs \\ %{}) do
    %Project{}
    |> insert_changeset(attrs)
    |> Repo.insert()
  end

  def update(%Project{} = project, attrs) do
    project
    |> update_changeset(attrs)
    |> Repo.update()
  end

  def delete(%Project{} = project) do
    Repo.delete(project)
  end

  def delete!(%Project{} = project), do: Repo.delete!(project)

  def delete do
    Repo.delete_all(Project)
  end

  defp generate_slug(owner, repo_name), do: "#{owner}/#{repo_name}"
end
