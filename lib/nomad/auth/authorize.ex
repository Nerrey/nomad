defmodule Nomad.Authorized do
  import Guardian.Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case current_resource(conn) do
      nil -> conn
            |> put_flash(:warning, "You’re not authorized!")
            |> redirect(to: NomadWeb.Router.Helpers.admin_session_path(conn, :new))
            |> halt()
      _   -> conn
    end
  end
end
