defmodule Nomad.Repo.Migrations.CreateAdmin do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string
      add :password_hash, :string

      timestamps()
    end
    create unique_index(:admins, [:name])

  end
end
