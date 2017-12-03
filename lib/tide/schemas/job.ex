defmodule Tide.Schemas.Job do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Tide.Repo
  alias Tide.Schemas.Job

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Poison.Encoder, only: [:id, :log, :status]}

  schema "jobs" do
    field(:status, :string)
    field(:log, {:array, :string}, default: [])

    belongs_to(:project, Tide.Schemas.Project)
    timestamps
  end

  @fields ~w(status log project_id)
  @statuses ~w(pending started cancelled success failure)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:status])
    |> validate_inclusion(:status, @statuses)
  end

  def list, do: Repo.all(Job)

  def list_pending do
    Repo.all(
      from(
        j in Job,
        where: j.status == "pending",
        order_by: [desc: j.inserted_at]
      )
    )
  end

  def list_jobs(project_id) do
    Repo.all(from(j in Job, where: j.project_id == ^project_id))
  end

  def get(id), do: Repo.get(Job, id)
  def get!(id), do: Repo.get!(Job, id)

  def create_job(attrs \\ %{}) do
    %Job{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update_job(%Job{} = job, attrs) do
    job
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  def delete_all do
    Repo.delete_all(Job)
  end
end
