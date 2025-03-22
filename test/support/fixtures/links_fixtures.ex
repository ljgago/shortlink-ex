defmodule Shortlink.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortlink.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        email: "test@test.com",
        long_url: "http://localhost:4000",
        code: "aBcDeFgHiJk",
        expire: ~U[2024-01-01 12:00:00Z],
      })
      |> Shortlink.Links.create_link()

    # visit_count returns nil when created
    link |> Map.put(:visit_count, 0)
  end
end
