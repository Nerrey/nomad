defmodule NomadWeb.PageController do
  use NomadWeb, :controller
  alias Nomad.Static
  alias Nomad.Blog
  alias Nomad.Resume

  def index(conn, _params) do
    static = Static |> where(type: ^:main) |> Repo.all |> List.first
    blogs = Blog |> order_by([b], desc: b.inserted_at) |> limit(3) |> Repo.all
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
    render conn, "index.html", info: static.info, study: study, expirience: expirience, blogs: blogs
  end

  def blog(conn, _params) do
    static = Static |> where(type: ^:main) |> Repo.all |> List.first
    blogs = Blog |> order_by([b], desc: b.inserted_at) |> Repo.all
    # .paginate(params)
    render conn, "blog.html", info: static.info, blogs: blogs
  end

  def blog_single(conn, %{"id" => id}) do
    static = Static |> where(type: ^:main) |> Repo.all |> List.first
    blog = Repo.get!(Blog, id)
    render conn, "blog_single.html", blog: blog, info: static.info
  end
end
