defmodule NomadWeb.PageController do
  use NomadWeb, :controller
  alias Nomad.Static

  def index(conn, _params) do
    static = Static |> where(type: ^:main) |> Repo.all |> List.first

    render conn, "index.html", info: static.info
  end

  def blog(conn, _params) do
    render conn, "blog.html"
  end

  def blog_single(conn, _params) do
    render conn, "blog_single.html"
  end
end
