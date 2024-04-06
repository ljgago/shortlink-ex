defmodule Shortex.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "links" do
    field :url, :string
    field :token, :string
    field :expire, :date

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:url, :token, :expire])
    |> validate_required([:url, :token, :expire])
  end
end
