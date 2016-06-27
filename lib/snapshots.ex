defmodule Snapshots do
  use Application

  def start( _type, _args ) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Snapshots.Server, [] )
    ]
    opts = [strategy: :one_for_one, name: Snapshots.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
