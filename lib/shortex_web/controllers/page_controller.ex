defmodule ShortexWeb.PageController do
  use ShortexWeb, :controller

  alias Shortex.Links

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def show_url(conn, %{"token" => token}) do
    case Links.get_link_by_token(token) do
      nil -> redirect(conn, to: "/not-found")
      link -> redirect(conn, external: link.url)
    end
  end
end
