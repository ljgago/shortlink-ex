defmodule Shortlink.Repo.Migrations.CreateBans do
  use Ecto.Migration

  def change do
    create table(:bans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :host, :string
      add :expire, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
