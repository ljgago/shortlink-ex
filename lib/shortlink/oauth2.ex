defmodule Shortlink.OAuth2 do
  alias Shortlink.OAuth2

  def get_provider(provider) do
    case provider do
      "github" ->
        OAuth2.Github

      "zitadel" ->
        OAuth2.Zitadel

      _ ->
        OAuth2.Zitadel
    end
  end
end
