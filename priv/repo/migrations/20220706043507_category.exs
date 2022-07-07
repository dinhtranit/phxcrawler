defmodule PhxCrawler.Repo.Migrations.Category do
  use Ecto.Migration

  def change do
    create table(:category) do
      add(:name, :string, unique: true)
    end
  end
end
