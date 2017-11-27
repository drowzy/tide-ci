defmodule Tide.Repo.Migrations.CreateProjectTable do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :slug, :string, null: false
      add :owner, :string, null: false
      add :vcs_url, :string, null: false
      add :description, :string

      timestamps()
    end
  end
end
