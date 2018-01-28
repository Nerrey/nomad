defmodule Nomad.Resume do
  use NomadWeb, :model

  schema "resumes" do
    field :type, ResumeType
    field :title, :string
    field :date, :string
    field :description, :string
    field :position, :integer

    timestamps()
  end

  @required_fields ~w(type)a
  @optional_fields ~w(title date description position)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
