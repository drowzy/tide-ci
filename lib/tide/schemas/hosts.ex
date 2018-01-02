defmodule Tide.Schemas.Host do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Tide.Repo
  alias Tide.Schemas.Host

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Poison.Encoder, only: [:id, :hostname, :name, :description, :credentials, :is_active]}

  schema "hosts" do
    field(:hostname, :string)
    field(:name, :string)
    field(:description, :string)
    field(:is_active, :boolean, default: true)

    embeds_one :credentials, Tide.Schemas.Credentials

    timestamps
  end

  @fields ~w(hostname name description is_active)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> cast_embed(:credentials)
    |> validate_required([:hostname, :is_active, :credentials])
    |> unique_constraint(:hostname)

    # TODO validate hostname is a URI/IP
  end

  def list, do: Repo.all(Host)

  def list_active do
    Repo.all(from(h in Host, where: h.is_active == true))
  end

  def get(id), do: Repo.get(Host, id)
  def get!(id), do: Repo.get!(Host, id)

  def create(attrs \\ %{}) do
    %Host{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(%Host{} = host, attrs) do
    host
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete(%Host{} = host) do
    Repo.delete(host)
  end

  def delete do
    Repo.delete_all(Host)
  end
end
