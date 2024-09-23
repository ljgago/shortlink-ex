defmodule ShortlinkWeb.LoginLive.Index do
  use ShortlinkWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    case ShortlinkWeb.AuthPlug.authenticated?(session) do
      true ->
        token = Map.get(session, "token", "")

        case token do
          "" -> {:ok, socket}
          _ -> {:ok, redirect(socket, to: ~p"/")}
        end

      false ->
        {:ok, socket}
    end
  end

  @impl true
  def handle_event("oauth-request", %{"url" => url}, socket) do
    {:noreply, redirect(socket, to: url)}
  end
end
