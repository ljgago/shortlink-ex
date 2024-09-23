defmodule ShortlinkWeb.LinksLive.Index do
  use ShortlinkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    %{path: path} = URI.parse(uri)

    {:noreply, assign(socket, :path, path)}
  end
end
