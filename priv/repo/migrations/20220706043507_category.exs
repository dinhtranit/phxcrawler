defmodule PhxCrawler.Repo.Migrations.Category do
  use Ecto.Migration

  def change do
    create table(:category) do
      add(:category_url, :text)
      add(:name, :string)
    end
    create unique_index(:category, [:category_url])
  end
end
