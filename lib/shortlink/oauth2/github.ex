defmodule Shortlink.OAuth2.Github do
  def config() do
    [
      client_id: get_config(:client_id),
      client_secret: get_config(:client_secret),
      base_url: get_config(:base_url),
      redirect_uri: get_config(:redirect_uri),
      authorize_url: get_config(:authorize_url),
      user_url: get_config(:user_url),
      token_url: get_config(:token_url),
      revoke_url: get_config(:revoke_url),
      authorization_params: get_config(:authorization_params),
      trusted_audiences: Jason.decode!(get_config(:trusted_audiences))
    ]
  end

  defp get_config(key) do
    :shortlink
    |> Application.fetch_env!(:github)
    |> Keyword.fetch!(key)
  end

  def authorize_url() do
    config()
    |> Assent.Strategy.OIDC.authorize_url()
  end

  def callback(conn, params) do
    config()
    |> Keyword.put(:session_params, Plug.Conn.get_session(conn, :session_params))
    |> Assent.Strategy.OIDC.callback(params)
  end

  @spec valid?(map()) :: boolean()
  def valid?(session) do
    case session do
      %{"session_params" => session_params, "token" => %{"id_token" => id_token}} ->
        valid =
          config()
          |> Keyword.put(:session_params, session_params)
          |> Assent.Strategy.OIDC.validate_id_token(id_token)

        case valid do
          {:ok, _} -> true
          _ -> false
        end

      _ ->
        false
    end
  end

  def refresh(token) do
    config()
    |> Assent.Strategy.OAuth2.refresh_access_token(
      token,
      client_secret: Keyword.get(config(), :client_secret, "")
    )
  end
end
