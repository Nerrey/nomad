defmodule NomadWeb.PageController do
  use NomadWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end