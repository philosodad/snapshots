use Mix.Config
config :snapshots, Snapshots.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  extensions: [{Postgrex.Extensions.JSON, library: Poison}]

