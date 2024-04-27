defmodule Shortlink.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shortlink.Links.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "links" do
    field :long_url, :string
    field :code, :string
    field :expire, :utc_datetime
    field :visit_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:long_url, :code, :expire])
    |> validate_required([:long_url, :code, :expire])
    |> unique_constraint(:code, name: :links_code_index)
    |> Utils.validate_url(:long_url)
  end
end
