defmodule NomadWeb.Admin.StaticController do
  use NomadWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
