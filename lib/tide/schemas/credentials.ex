defmodule Tide.Schemas.Credentials do
  use Ecto.Schema

  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :user, :string
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:user])
    |> validate_required([:user])
  end
end
