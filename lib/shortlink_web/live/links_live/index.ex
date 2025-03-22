defmodule ShortlinkWeb.LinksLive.Index do
  use ShortlinkWeb, :live_view

  alias Shortlink.Links

  @impl true
  def mount(_params, _session, socket) do
    links =
      Links.list_links_by_email(socket.assigns.current_user)
      |> Enum.map(fn link ->
        short_url =
          URI.append_path(socket.host_uri, "/#{link.code}")
          |> URI.to_string()

        %{
          long_url: link.long_url,
          short_url: short_url,
          visit_count: link.visit_count,
          expire: Calendar.strftime(link.expire, "%Y-%m-%d %H:%M:%S")
        }
      end)

    {:ok, assign(socket, links: links)}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    %{path: path} = URI.parse(uri)

    {:noreply, assign(socket, :path, path)}
  end
end
