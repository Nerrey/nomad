alias Nomad.Repo
alias Nomad.Admin
alias Nomad.Static

if !Repo.get_by(Admin, name: "admin") do
  Repo.insert!(%Admin{
    name: "admin",
    password_hash: Comeonin.Bcrypt.hashpwsalt("password")
  })
end

Repo.delete_all(Static)
Repo.insert_all(Static, rows)
