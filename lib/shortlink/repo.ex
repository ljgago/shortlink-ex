defmodule Shortlink.Repo do
  use Ecto.Repo,
    otp_app: :shortlink,
    adapter: Ecto.Adapters.Postgres
end
