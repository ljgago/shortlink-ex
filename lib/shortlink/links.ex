defmodule Shortlink.Links do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Shortlink.Repo
  alias Shortlink.Links.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links() do
    Repo.all(Link)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Account{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Gets a single link.any()

  Returns 'nil' if the Link does not exist.

  ## Examples

      iex> get_link_by_code("kahj4KLEhcTteEIK")
      %Link{}

      iex> get_link_by_code("123456789abcdefg")
      nil

  """
  def get_link_by_code(code) do
    Link
    |> where(code: ^code)
    |> Repo.one()
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Refresh the link updating the expiry date and incrementing the visit count
  """
  def refresh_link(%Link{} = link) do
    new_expire = DateTime.utc_now(:second) |> DateTime.add(7, :day)

    link
    |> Ecto.Changeset.change(
      expire: new_expire,
      visit_count: link.visit_count + 1
    )
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Delete expired links.

  ## Examples

      iex> delete_expired_links()
      {1, [%Link{}]}

  """
  def delete_expired_links() do
    from(l in Link, where: l.expire < ^DateTime.utc_now())
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
