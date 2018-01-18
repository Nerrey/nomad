defmodule NomadWeb.Router do
  use NomadWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_layout do
    plug :put_layout, {NomadWeb.LayoutView, "admin.html"}
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Nomad.CurrentAdmin
  end

  pipeline :check_auth do
    plug Nomad.Authorized
  end

  scope "/", NomadWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/admin", as: :admin, alias: NomadWeb.Admin do
    pipe_through [:browser, :admin_layout, :with_session]
    resources "/sessions", SessionController, only: [:new, :create]

    pipe_through [:check_auth] # Use the default browser stack
    get "/static", StaticController, :index
    get "/sessions/logout/:id", SessionController, :logout
    resources "/admins", AdminController
  end

  # Other scopes may use custom stacks.
  # scope "/api", NomadWeb do
  #   pipe_through :api
  # end
end
