# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dnd_tracker,
  ecto_repos: [DndTracker.Repo]

# Configures the endpoint
config :dnd_tracker, DndTrackerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DndTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: DndTracker.PubSub,
  live_view: [signing_salt: "2fyH3tJX"]

config :dnd_tracker, DndTracker.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, :api_client, false

config :esbuild,
  version: "0.14.0",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
