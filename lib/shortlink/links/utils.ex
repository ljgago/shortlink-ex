defmodule Shortlink.Links.Utils do
  @doc """
  Validates a change is a valid URL.

  """
  @spec validate_url(Ecto.Changeset.t(), atom(), keyword()) :: Ecto.Changeset.t()
  def validate_url(changeset, field, opts \\ []) do
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
