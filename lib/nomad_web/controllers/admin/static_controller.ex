defmodule NomadWeb.Admin.StaticController do
  use NomadWeb, :controller
  alias Nomad.Static

  def index(conn, _params) do
    render conn, "index.html"
  end

  def update(conn, %{"id" => id} = params) do
    static = Repo.get!(Static, id)
    changeset = Static.changeset(static, params)

    case Repo.update(changeset) do
      {:ok, static} ->
        conn
        |> put_flash(:info, "Успешно обновлено.")
        |> redirect(to: static_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
