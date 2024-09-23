defmodule ShortlinkWeb.AuthPlug do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  use ShortlinkWeb, :verified_routes

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    if authenticated?(get_session(conn)) do
      conn
    else
      conn
      |> redirect(to: ~p"/_/login")
    end
  end

  @spec authenticated?(map()) :: boolean()
  def authenticated?(session) do
    case session do
      %{"session_params" => session_params, "token" => %{"id_token" => id_token}} ->
        valid =
          Shortlink.OAuth2.Zitadel.config()
          |> Assent.Config.put(:session_params, session_params)
          |> Assent.Strategy.OIDC.validate_id_token(id_token)

        case valid do
          {:ok, _} -> true
          _ -> false
        end

      _ ->
        false
    end
  end
end
