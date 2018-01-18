# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nomad,
  ecto_repos: [Nomad.Repo]

# Configures the endpoint
config :nomad, NomadWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bOdu3xLlqn5KGiWd37nchplH1BL5DZeB0gn9eO+2b3MRYrCKWtdZQU1poyY6i0FE",
  render_errors: [view: NomadWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nomad.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
    slim: PhoenixSlime.Engine,
    slime: PhoenixSlime.Engine

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Nomad",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: to_string(Mix.env) <> "oq387tgiq873tf9n873",
  serializer: Nomad.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
