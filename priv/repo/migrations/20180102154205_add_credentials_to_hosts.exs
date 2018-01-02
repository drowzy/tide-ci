defmodule Tide.Repo.Migrations.AddCredentialsToHosts do
  use Ecto.Migration

  def change do
    alter table(:hosts) do
      add :credentials, :map
    end
  end
end
