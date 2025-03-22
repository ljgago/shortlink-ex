defmodule ShortlinkWeb.HomeLiveTest do
  use ShortlinkWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "home live" do
    test "unauthenticated user", %{conn: conn} do
      {:error, {:redirect, %{to: "/_/login", flash: %{}}}} = live(conn, ~p"/")
    end
  end
end
