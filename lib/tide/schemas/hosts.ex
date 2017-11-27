defmodule Tide.Schemas.Host do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Tide.Repo
  alias Tide.Schemas.Host

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Poison.Encoder, only: [:id, :hostname, :name, :description, :is_active]}

  schema "hosts" do
    field(:hostname, :string)
    field(:name, :string)
    field(:description, :string)
    field(:is_active, :boolean, default: true)

    timestamps
  end

  @fields ~w(hostname name description is_active)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:hostname, :is_active])
    |> unique_constraint(:hostname)

    # TODO validate hostname is a URI/IP
  end

  def list, do: Repo.all(Host)
  def get(id), do: Repo.get(Host, id)
  def get!(id), do: Repo.get!(Host, id)

  def create(attrs \\ %{}) do
    %Host{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(%Host{} = job, attrs) do
    job
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete(%Host{} = job) do
    Repo.delete(job)
  end

  def delete do
    Repo.delete_all(Host)
  end
end
