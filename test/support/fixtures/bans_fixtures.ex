defmodule Shortlink.BansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortlink.Bans` context.
  """

  @doc """
  Generate a ban.
  """
  def ban_fixture(attrs \\ %{}) do
    {:ok, ban} =
      attrs
      |> Enum.into(%{
        expire: ~U[2024-04-25 00:20:00Z],
        host: "some host"
      })
      |> Shortlink.Bans.create_ban()

    ban
  end
end
