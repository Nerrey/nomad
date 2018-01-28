defmodule Nomad.Repo.Migrations.Blog do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :image, :text
      add :title, :string
      add :description, :text

      timestamps()
    end
  end
end
