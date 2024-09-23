defmodule ShortlinkWeb.AuthHook do
  use ShortlinkWeb, :live_view
  use ShortlinkWeb, :verified_routes

  def on_mount(:default, _params, session, socket) do
    if ShortlinkWeb.AuthPlug.authenticated?(session) do
      {:cont,
       assign(socket,
         path: "",
         current_user: user_from_session(session)
       )}
    else
      {:halt, redirect(socket, to: ~p"/_/login")}
    end
  end

  defp user_from_session(session) do
    get_in(session, ["user", "email"])
  end
end
