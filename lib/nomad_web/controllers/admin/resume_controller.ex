defmodule NomadWeb.Admin.ResumeController do
  use NomadWeb, :controller
  alias Nomad.Resume

  def index(conn, _params) do
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
    changeset =  Resume.changeset(%Resume{}, %{})
    render conn, "index.html", changeset: changeset, study: study, expirience: expirience
  end

  def create(conn, %{"resume" => resume_params}) do
    changeset = %Resume{} |> Resume.changeset(resume_params)

    case Repo.insert(changeset) do
      {:ok, _resume} ->
        conn
        |> put_flash(:info, "Resume created successfully.")
        |> redirect(to: admin_resume_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resume = Repo.get!(Resume, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(resume)

    conn
    |> put_flash(:info, "Resume deleted successfully.")
    |> redirect(to: admin_resume_path(conn, :index))
  end
end
