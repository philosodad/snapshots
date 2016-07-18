defmodule Snapshots.Repo.Migrations.AddSnapshots do
  use Ecto.Migration

  def change do
    create table(:snapshots) do
      add :guid, :string
      add :ref_guid, :string
      add :message, :map
    end
  end
end
