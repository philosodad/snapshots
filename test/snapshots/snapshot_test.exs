defmodule Snapshots.SnapshotTest do
  require IEx
  use ExUnit.Case
  alias Snapshots.Snapshot
  doctest Snapshots.Snapshot

  test "creates the new snapshot" do
    
    guid = :rand.uniform(1000000000000)
       |> Kernel.+(1000000000000)
       |> Integer.to_string(16)
    json = %{play: "that", funky: "music"}
    %Snapshot{guid: guid, ref_guid: "456", message: json}
    |> Snapshots.Repo.insert
    snap = Snapshots.Repo.get_by!(Snapshot, guid: guid)
    assert snap.message["play"] == "that"
  end
end
