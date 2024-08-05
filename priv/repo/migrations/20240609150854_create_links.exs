defmodule Shortlink.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      # add :user_id, references(:users, on_delete: :delete_all, type: :binary_id, name: :id), null: false
      add :long_url, :string
      add :code, :string
      add :expire, :utc_datetime
      add :visit_count, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, [:code])
  end
end
