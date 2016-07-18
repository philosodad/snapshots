defmodule Sets do
  import EnvHelper
  app_env(:http, [:snapshots, :http], Snapshots.HTTP)
  system_env(:auth_token, "anything")
  system_env(:snapshots_url, "http://fakehost")
  case Mix.env do
    :prod ->
      system_env(:port, 4000, :string_to_integer)
    _ ->
      app_env(:port, [:snapshots, :port], 25679)
  end
end
