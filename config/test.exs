use Mix.Config
config :snapshots, port: 25677 

config :snapshots, Snapshots.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snapshots_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  extensions: [{Postgrex.Extensions.JSON, library: Poison}]
