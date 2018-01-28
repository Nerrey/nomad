defmodule NomadWeb.Admin.StaticController do
  use NomadWeb, :controller
  alias Nomad.Static

  def index(conn, _params) do
    static = Static |> where(type: ^:main) |> Repo.all |> List.first
    changeset =  Static.changeset(static, %{})
    render conn, "index.html", changeset: changeset, static: static
  end

  def update(conn, %{"static" => static_params} = params) do
    static = Repo.get!(Static, params["id"])
    synytize_params = %{"info" => Map.merge(static.info, static_params["info"])}
    changeset = Static.changeset(static, synytize_params)
    case Repo.update(changeset) do
      {:ok, static} ->
        conn
        |> put_flash(:info, "Успешно обновлено.")
        |> redirect(to: admin_static_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
