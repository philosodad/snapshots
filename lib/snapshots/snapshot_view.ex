defmodule Snapshots.SnapshotView do
  alias Snapshots.Snapshot
  def return_snapshot guid do
    case Snapshots.Repo.get_by(Snapshot, guid: guid) do
      nil -> {:error, Poison.encode!(%{error: "No resource found for id: #{guid}"})}
      snapshot -> {:ok, build_snapshot_view(snapshot)}
    end
  end

  defp build_snapshot_view snapshot do
    %{
      href: "#{Sets.snapshots_url}/snapshot/#{snapshot.guid}",
      snapshot: snapshot.message
    }
    |> Poison.encode!
  end
end
