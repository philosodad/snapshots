defmodule Snapshots.Snapshot do
  use Ecto.Schema
  
  schema "snapshots" do
    field :guid, :string
    field :ref_guid, :string
    field :message, :map
  end

end
