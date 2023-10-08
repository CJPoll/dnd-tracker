use Mix.Config

# Configure your database
config :dnd_tracker, DndTracker.Repo,
  username: "postgres",
  password: "postgres",
  database: "dnd_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dnd_tracker, DndTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: false

config :dnd_tracker, DndTracker.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime
