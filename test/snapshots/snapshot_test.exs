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

  test "#create returns an error if missing guid header" do
    {:error, message} = Snapshot.create %{"body" => %{a: "map"}, "x-ref-guid" => "hello"}
    assert message == "No x-guid header found"
  end

  test "#create returns an error if missing ref-guid header" do
    {:error, message} = Snapshot.create %{"x-guid" => "asdfsadfasdf", "body" => %{mana: "mana"}}
    assert message == "No x-ref-guid header found"
  end

  test "#create returns an error if missing message params" do
    {:error, message} = Snapshot.create %{"x-guid" => "adasdfsadf", "x-ref-guid" => "isdfj23[09rukj"}
    assert message == "No snapshot found"
  end

  test "#create returns errors for all the missing things" do
    {:error, message} = Snapshot.create %{}
    assert message =~ "No snapshot found"
    assert message =~ "No x-ref-guid header found"
    assert message =~ "No x-guid header found"
  end
end
