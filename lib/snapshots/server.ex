defmodule Snapshots.Server do
  use Plug.Router
  alias Plug.Adapters.Cowboy
  plug :match
  plug :dispatch


  def start_link do
    Cowboy.http Snapshots.Server, [], port: Sets.port
  end
  get _ do
    send_resp(conn, 404, "Nothin' to see here")
  end
end
