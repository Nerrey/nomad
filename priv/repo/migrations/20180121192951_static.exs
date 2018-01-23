defmodule Nomad.Repo.Migrations.Static do
  use Ecto.Migration

  def change do
    create table(:statics) do
      add :type, :integer
      add :info, :map

      timestamps()
    end
  end
end
