defmodule Snapshots.Server do
  require IEx
  use Plug.Router
  alias Plug.Adapters.Cowboy
  plug :authorize
  plug :match
  plug :dispatch

  def start_link do
    Cowboy.http Snapshots.Server, [], port: Sets.port
  end

  post "/snapshot" do
    send_resp(conn, 201, "")
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
