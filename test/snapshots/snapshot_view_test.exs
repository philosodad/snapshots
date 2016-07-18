defmodule Snapshots.SnapshotViewTest do
  alias Snapshots.SnapshotView
  alias Snapshots.Snapshot
  use ExUnit.Case

  test "returns error not found if no snapshot" do
    a_guid = guid
    {:error, body} = SnapshotView.return_snapshot a_guid
    assert body == Poison.encode! %{error: "No resource found for id: #{a_guid}"}
  end

  test "returns snapshot if snapshot found" do
    a_guid = guid
    ref_guid = guid
    message =  %{you: "can", go: "with", this: "that"}
    %Snapshot{guid: a_guid, ref_guid: ref_guid, message: message} 
    |> Snapshots.Repo.insert
    expected_return = %{href: "#{Sets.snapshots_url}/snapshot/#{a_guid}", snapshot: message}
    |> Poison.encode!
    {:ok, body} = SnapshotView.return_snapshot a_guid
    assert body == expected_return
  end

  def guid do
    guid = (:rand.uniform(256) + 256) |> Integer.to_string(16)
  end
end
