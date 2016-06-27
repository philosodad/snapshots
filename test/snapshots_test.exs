defmodule SnapshotsTest do
  use ExUnit.Case
  doctest Snapshots

  test "server will respond with 404" do
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/nothere")
    assert response.status_code == 404 
  end
end
