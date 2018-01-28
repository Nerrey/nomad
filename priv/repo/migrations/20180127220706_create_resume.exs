defmodule Nomad.Repo.Migrations.CreateResume do
  use Ecto.Migration

  def change do
    create table(:resumes) do
      add :type, :integer
      add :title, :string
      add :date, :string
      add :description, :text
      add :position, :integer

      timestamps()
    end
  end
end
