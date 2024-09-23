defmodule Shortlink.Repo.Migrations.CreateLinksTable do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :long_url, :string, null: false
      add :code, :string, null: false
      add :visit_count, :integer, default: 0, null: false
      add :expire, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, [:code])
  end
end
