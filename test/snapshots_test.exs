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

  test "/snapshot/:id will return a 404 if no snapshot found" do
    guid = :rand.uniform(1000000000000)
       |> Kernel.+(1000000000000)
       |> Integer.to_string(16)
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/snapshot/#{guid}", %{"Authorization": "anything"})
    assert response.status_code == 404
    assert response.body == Poison.encode!(%{error: "No resource found for id: #{guid}"})
  end

  test "/snapshot/:id will retrive a snapshot record in JSON format" do
    guid = :rand.uniform(1000000000000)
       |> Kernel.+(1000000000000)
       |> Integer.to_string(16)
    json = %{play: "that", funky: "music"}
    %Snapshots.Snapshot{guid: guid, ref_guid: "456", message: json}
    |> Snapshots.Repo.insert
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/snapshot/#{guid}", %{"Authorization": "anything"})
    assert response.status_code == 200
    body = Poison.decode! response.body
    assert body["href"] == "#{Sets.snapshots_url}/snapshot/#{guid}"
  end
end
