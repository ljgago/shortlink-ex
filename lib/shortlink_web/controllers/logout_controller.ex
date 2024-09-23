defmodule ShortlinkWeb.LogoutController do
  use ShortlinkWeb, :controller

  def logout(conn, _opts) do
    conn
    |> delete_session("user")
    |> delete_session("token")
    |> redirect(to: ~p"/_/login")
  end
end
