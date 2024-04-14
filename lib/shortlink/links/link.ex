defmodule Shortlink.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shortlink.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "links" do
    field :long_url, :string
    field :token, :string
    field :expire, :date

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:long_url, :token, :expire])
    |> validate_required([:long_url, :token, :expire])
    |> Utils.validate_url(:long_url)
  end
end
