defmodule Nomad.GuardianSerializer do

  @behaviour Guardian.Serializer

  alias Nomad.Repo
  alias Nomad.Admin

  def for_token(%Admin{} = admin), do: {:ok, "Admin:#{admin.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("Admin:" <> id), do: {:ok, Repo.get(Admin, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
