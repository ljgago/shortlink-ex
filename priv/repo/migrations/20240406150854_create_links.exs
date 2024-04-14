defmodule Shortex.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :long_url, :string
      add :token, :string
      add :expire, :date

      timestamps()
    end
  end
end
