defmodule NomadWeb.PageController do
  use NomadWeb, :controller
  alias Nomad.Static
  alias Nomad.Resume

  def index(conn, _params) do
    static = Static |> where(type: ^:main) |> Repo.all |> List.first
    study =
      Resume
      |> where([r], r.type == ^:study)
      |> order_by([r], asc: r.position)
      |> Repo.all
    expirience =
      Resume
      |> where([r], r.type == ^:project)
      |> order_by([r], asc: r.position)
      |> Repo.all
    render conn, "index.html", info: static.info, study: study, expirience: expirience
  end

  def blog(conn, _params) do
    render conn, "blog.html"
  end

  def blog_single(conn, _params) do
    render conn, "blog_single.html"
  end
end
