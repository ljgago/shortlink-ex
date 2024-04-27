defmodule Shortlink.Bans.Ban do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bans" do
    field :expire, :utc_datetime
    field :host, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ban, attrs) do
    ban
    |> cast(attrs, [:host, :expire])
    |> validate_required([:host, :expire])
  end
end
