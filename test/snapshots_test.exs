defmodule SnapshotsTest do
  use ExUnit.Case
  doctest Snapshots

  test "server will respond with 404" do
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/nothere", %{"Authorization": "anything"})
    assert response.status_code == 404 
    assert response.body == "Nothin' to see here"
  end

  test "server will reject an unauthorized request" do
    {:ok, response} = Sets.http.post("localhost:#{Sets.port}/snapshot", [])
    assert response.status_code == 404
    assert response.body == "No resource found"
  end

  test "server will return 201 for an authorized request" do
    {:ok, response} = Sets.http.post("localhost:#{Sets.port}/snapshot","", %{"Authorization": "anything"})
    assert response.status_code == 201
  end
end
