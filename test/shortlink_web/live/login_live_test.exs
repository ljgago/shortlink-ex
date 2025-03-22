defmodule ShortlinkWeb.LoginLiveTest do
  use ShortlinkWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "login live" do
    test "check login button", %{conn: conn} do
      {:ok, view, _} = live(conn, ~p"/_/login")

      assert {:error, {:redirect, %{to: "/_/oauth/request/zitadel"}}} =
               view
               |> element("button#login")
               |> render_click()
    end
  end
end
