defmodule Nomad.Blog do
  use NomadWeb, :model

  schema "blogs" do
    field :image, :string
    field :title, :string
    field :description, :string

    timestamps()
  end

  @required_fields ~w()a
  @optional_fields ~w(image title description)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
