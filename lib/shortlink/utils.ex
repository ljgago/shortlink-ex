defmodule Shortlink.Utils do
  # @doc """
  # Validates if the given URL is syntactically valid.
  #
  # ## Examples
  #
  #     iex> Shortlink.Utils.valid_url?("not_a_url")
  #     false
  #
  #     iex> Shortlink.Utils.valid_url?("https://example.com")
  #     true
  #
  #     iex> Shortlink.Utils.valid_url?("http://localhost")
  #     true
  #
  #     iex> Shortlink.Utils.valid_url?("http://")
  #     false
  #
  # """
  # @spec valid_url?(String.t()) :: boolean()
  # def valid_url?(url) do
  #   uri = URI.parse(url)
  #   uri.scheme != nil and uri.host not in [nil, ""]
  # end


  @doc """
  Validates a change is a valid URL.

  """
  # @spec validate_url(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  # def validate_url(changeset, field) do
  #   Ecto.Changeset.validate_change(changeset, field, fn ^field, url ->
  #     if valid_url?(url) do
  #       []
  #     else
  #       [{field, "must be a valid URL"}]
  #     end
  #   end)
  # end


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
