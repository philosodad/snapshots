defmodule Snapshots.Snapshot do
  require IEx
  use Ecto.Schema
  import Ecto.Changeset

  schema "snapshots" do
    field :guid, :string
    field :ref_guid, :string
    field :message, :map
  end

  def create map do
    params = %{"x-guid" => :guid, "body" => :message, "x-ref-guid" => :ref_guid}
             |> Enum.reduce(%{},
                            fn({key, value}, acc) ->
                              Map.put(acc,
                                      value,
                                      Map.get(map, key))
                            end
                            )
    changes = changeset %Snapshots.Snapshot{}, params
    case Snapshots.Repo.insert(changes) do
      {:ok, _message} -> {:ok, "ok"}
      {:error, _errors} -> {:error, error_from_changeset(changes)}
    end
  end

  def changeset snapshot, params do
    cast(snapshot, params, [:message, :guid, :ref_guid])
    |> validate_required([:message, :guid, :ref_guid])
  end

  defp error_from_changeset(changes) do
    %{
      guid: "No x-guid header found",
      ref_guid: "No x-ref-guid header found",
      message: "No snapshot found"
    }
    |> Enum.filter_map(
                        fn({key, _value}) ->
                          List.keymember?(changes.errors,
                          key,
                          0)
                        end,
                        fn({_key, value}) -> 
                          value 
                        end
                      )
    |> Enum.join(",")
  end

end
