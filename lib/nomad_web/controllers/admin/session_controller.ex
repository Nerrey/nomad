defmodule NomadWeb.Admin.SessionController do
  use NomadWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Nomad.Admin

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"name" => name, "password" => password}}) do
    admin = Repo.get_by(Admin, name: name)
    result = cond do
      admin && checkpw(password, admin.password_hash) ->
        {:ok, login(conn, admin)}
      admin ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: admin_static_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid name/password combination")
        |> render("new.html")
    end
  end

  def logout(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  defp login(conn, admin) do
    conn
    |> Guardian.Plug.sign_in(admin)
  end
end
