defmodule Tide.Repo.Migrations.AddUniqueIndexOnHosts do
  use Ecto.Migration

  def up do
    create unique_index(:hosts, [:hostname])
  end

  def down do
    drop unique_index(:hosts, [:hostname])
  end
end
