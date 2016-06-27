defmodule Sets do
  import EnvHelper
  app_env(:http, [:snapshots, :http], Snapshots.HTTP)
  system_env(:port, 25679, :string_to_integer)
end
