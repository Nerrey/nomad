defmodule NomadWeb.Admin.BlogController do
  use NomadWeb, :controller
  alias NomadWeb.Services.PathCreator
  alias NomadWeb.Services.S3

  alias Nomad.Blog

  def index(conn, _params) do
    blogs =
      Blog
      |> order_by([b], desc: b.inserted_at)
      |> Repo.all
    render(conn, "index.html", blogs: blogs)
  end

  def new(conn, _params) do
    changeset = Blog.changeset(%Blog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"blog" => blog_params}) do
    params = blog_params |> Map.merge(%{"image" => blog_params["image"]})
    changeset = %Blog{} |> Blog.changeset(sanytize_params(blog_params))

    case Repo.insert(changeset) do
      {:ok, blog} ->
        upload(blog, blog_params)
        conn
        |> put_flash(:info, "Blog created successfully.")
        |> redirect(to: admin_blog_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    blog = Repo.get!(Blog, id)
    changeset = Blog.changeset(blog)
    render(conn, "edit.html", blog: blog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Repo.get!(Blog, id)
    changeset = Blog.changeset(blog, sanytize_params(blog_params))

    case Repo.update(changeset) do
      {:ok, new_blog} ->
        S3.delete_object(blog)
        upload(new_blog, blog_params)
        conn
        |> put_flash(:info, "Blog updated successfully.")
        |> redirect(to: admin_blog_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Repo.get!(Blog, id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(blog)
    S3.delete_object(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: admin_blog_path(conn, :index))
  end

  defp upload(model, %{"image" => nil}), do: nil
  defp upload(model, %{"image" => file_data}) do
    S3.upload_to_s3(model, file_data)
    changeset = Blog.changeset(model, %{image: PathCreator.file_path(model, file_data.filename)})
    Repo.update(changeset)
  end
  defp upload(_model, _data), do: nil

  defp sanytize_params(%{"image" => _image} = params) do
    params |> Map.drop(["image"])
  end
  defp sanytize_params(params), do: params
end
