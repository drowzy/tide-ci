defmodule Tide.Repo.Migrations.AddHostTable do
  use Ecto.Migration

  def change do
    create table(:hosts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :hostname, :string, null: false
      add :name, :string
      add :description, :string
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end
  end
end
