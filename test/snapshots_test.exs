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

  test "/snapshot/:id will return a 404 if no snapshot found" do
    guid = :rand.uniform(1000000000000)
       |> Kernel.+(1000000000000)
       |> Integer.to_string(16)
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/snapshot/#{guid}", %{"Authorization": "anything"})
    assert response.status_code == 404
    assert response.body == Poison.encode!(%{error: "No resource found for id: #{guid}"})
  end

  test "/snapshot/:id will retrive a snapshot record in JSON format" do
    guid = new_guid
    json = %{play: "that", funky: "music"}
    %Snapshots.Snapshot{guid: guid, ref_guid: "456", message: json}
    |> Snapshots.Repo.insert
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/snapshot/#{guid}", %{"Authorization": "anything"})
    assert response.status_code == 200
    body = Poison.decode! response.body
    assert body["href"] == "#{Sets.snapshots_url}/snapshot/#{guid}"
  end

  test "post /snapshot will return 400 on bad request" do
    guid = new_guid
    {:ok, response} = Sets.http.post("localhost:#{Sets.port}/snapshot",Poison.encode!(%{body: %{the: "body", of: "the"}, request: "some url"}), %{"Content-Type": "application/json", "Authorization": "anything", "X-Ref-Guid": new_guid})
    assert response.status_code == 400
  end

  @tag :pending
  test "post /snapshot will insert a snapshot record" do
    guid = new_guid
    Sets.http.post("localhost:#{Sets.port}/snapshot",Poison.encode!(%{body: %{the: "body", of: "the"}, request: "some url"}), %{"Content-Type": "application/json", "Authorization": "anything", "X-GUID": "#{guid}", "X-Ref-Guid": new_guid})
    {:ok, response} = Sets.http.get("localhost:#{Sets.port}/snapshot/#{guid}", %{"Authorization": "anything"})
    body = Poison.decode! response.body
    assert response.status_code == 201
    assert body["snapshot"] == %{"body" => %{"the" => "body", "of" => "the"}, "request" => "some url"}
  end

  def new_guid do
    :rand.uniform(1000000000000)
    |> Kernel.+(1000000000000)
    |> Integer.to_string(16)
  end

end
