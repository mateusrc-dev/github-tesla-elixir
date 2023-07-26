# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :githubapi,
  ecto_repos: [Githubapi.Repo]

config :githubapi, Githubapi.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures the endpoint
config :githubapi, GithubapiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Pm3CHK03L8ef2lZv2Fl9eq3BLOBvQ3l6d7Cg4dPyuWPfYJvOJkbJs6uVN77Uv/t6",
  render_errors: [view: GithubapiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Githubapi.PubSub,
  live_view: [signing_salt: "xRkHnyTY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
