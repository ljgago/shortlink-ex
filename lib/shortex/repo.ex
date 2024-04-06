defmodule Shortex.Repo do
  use Ecto.Repo,
    otp_app: :shortex,
    adapter: Ecto.Adapters.Postgres
end
