import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :artist_discovery, ArtistDiscovery.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "artist_discovery_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :artist_discovery, ArtistDiscoveryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IgQqwfzskZ28CVT6nlxdan2b6GbRVP3J/+IMPX8jJYdixZArC8GW71I1g1FYZ0UV",
  server: false

# In test we don't send emails.
config :artist_discovery, ArtistDiscovery.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
