alias Nomad.Repo
alias Nomad.Admin

if !Repo.get_by(Admin, name: "admin") do
  Repo.insert! %Admin{
    name: "admin",
    password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
  }
end
