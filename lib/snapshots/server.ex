defmodule Snapshots.Server do
  use Plug.Router
  alias Plug.Adapters.Cowboy
  plug :authorize
  plug :match
  plug :dispatch

  def start_link do
    Cowboy.http Snapshots.Server, [], port: Sets.port
  end

  post "/snapshot" do
    headers = conn.req_headers
    {:ok, body, conn} = Plug.Conn.read_body(conn)
      
    send_resp(conn, 201, "snapshot captured")
  end

  get "/snapshot/:id" do
    case Snapshots.SnapshotView.return_snapshot id do
      {:error, message} -> send_resp(conn, 404, message)
      {:ok, snapshot} -> send_resp(conn, 200, snapshot)
    end
  end

  match _ do
    send_resp(conn, 404, "Nothin' to see here")
  end

  defp authorize conn, opts do
    token = Sets.auth_token
    Plug.Conn.get_req_header(conn, "authorization")
    |> Enum.member?(token)
    |> case do
      true -> conn
      _ -> send_resp(conn, 404, "No resource found")
           |> halt
    end
  end
end
