defmodule Nomad.Static do
  use NomadWeb, :model

  schema "statics" do
    field :type, StaticType
    field :info, :map

    timestamps()
  end

  @required_fields ~w(type)a
  @optional_fields ~w(info)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
