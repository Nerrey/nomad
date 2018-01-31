alias Nomad.Repo
alias Nomad.Admin
alias Nomad.Static

if !Repo.get_by(Admin, name: "admin") do
  Repo.insert!(%Admin{
    name: "admin",
    password_hash: Comeonin.Bcrypt.hashpwsalt("password")
  })
end

rows =
  [
    %{
      type: :main,
      info: %{a: :b}
    },
    %{
      type: :about,
      info: %{a: :b}
    }
  ]
  |> Enum.map(
    &(&1
      |> Map.merge(%{
        inserted_at: Timex.now(),
        updated_at: Timex.now()
      }))
  )

Repo.delete_all(Static)
Repo.insert_all(Static, rows)
