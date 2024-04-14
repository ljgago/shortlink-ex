defmodule ShortlinkWeb.PageController do
  use ShortlinkWeb, :controller

  alias Shortlink.Links
  alias ShortlinkWeb.FallbackController

  action_fallback FallbackController

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def show_url(conn, %{"token" => token}) do
    case Links.get_link_by_token(token) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: ShortlinkWeb.ErrorHTML)
        |> render(:"404")

      link ->
        redirect(conn, external: link.long_url)
    end
  end
end
