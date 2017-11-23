defmodule Tide.Repo.Migrations.AddJobsTable do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string, null: false
      add :log, {:array, :string}

      timestamps()
    end
  end
end
