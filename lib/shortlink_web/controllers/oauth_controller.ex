defmodule ShortlinkWeb.OAuthController do
  use ShortlinkWeb, :controller

  def request(conn, %{"provider" => provider}) do
    oauth2_provider = Shortlink.OAuth2.get_provider(provider)

    oauth2_provider.authorize_url()
    |> case do
      {:ok, %{url: url, session_params: session_params}} ->
        conn
        |> put_session(:session_params, session_params)
        |> redirect(external: url)

      {:error, reason} ->
        conn
        |> put_flash(:error, "Request failed: #{reason}")
        |> redirect(to: ~p"/_/login")
    end
  end

  def callback(conn, %{"provider" => provider} = params) do
    oauth2_provider = Shortlink.OAuth2.get_provider(provider)

    oauth2_provider.callback(conn, params)
    |> case do
      {:ok, %{user: user, token: token}} ->
        conn
        |> put_session(:user, user)
        |> put_session(:token, token)
        |> put_flash(:info, "Successfully authenticated!")
        |> redirect(to: ~p"/")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Authentication failed: #{inspect(reason)}")
        |> redirect(to: ~p"/_/login")
    end
  end
end
