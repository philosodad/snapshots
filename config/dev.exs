use Mix.Config

config :snapshots, Snapshots.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snapshots_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  extensions: [{Postgrex.Extensions.JSON, library: Poison}]

