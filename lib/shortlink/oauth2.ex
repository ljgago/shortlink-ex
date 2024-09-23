defmodule Shortlink.OAuth2 do
  def get_provider(provider) do
    case provider do
      "github" ->
        nil

      "zitadel" ->
        Shortlink.OAuth2.Zitadel

      _ ->
        Shortlink.OAuth2.Zitadel
    end
  end
end
