defmodule Tide.Repo.Migrations.ReferenceProjectJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :project_id, references(:projects, on_delete: :delete_all, type: :uuid), null: false
    end
  end
end
