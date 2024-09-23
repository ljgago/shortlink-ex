defmodule Shortlink.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "links" do
    field :email, :string
    field :long_url, :string
    field :code, :string
    field :visit_count, :integer
    field :expire, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:email, :long_url, :code, :expire])
    |> validate_required([:email, :long_url, :code, :expire])
    |> unique_constraint(:code, name: :links_code_index)
    |> validate_url(:long_url)
  end

  @spec validate_url(Ecto.Changeset.t(), atom(), keyword()) :: Ecto.Changeset.t()
  defp validate_url(changeset, field, opts \\ []) do
    Ecto.Changeset.validate_change(changeset, field, fn ^field, long_url ->
      case URI.parse(long_url) do
        %URI{scheme: nil} ->
          "is missing a scheme (e.g. https)"

        %URI{host: nil} ->
          "is missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end
end
