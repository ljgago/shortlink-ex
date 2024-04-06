defmodule Shortex.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :token, :string
      add :expire, :date

      timestamps()
    end
  end
end
