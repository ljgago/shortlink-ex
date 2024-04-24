defmodule Shortlink.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :long_url, :string
      add :code, :string
      add :expire, :utc_datetime
      add :visit_count, :integer, default: 0

      timestamps()
    end

    create unique_index(:links, [:code])
  end
end
