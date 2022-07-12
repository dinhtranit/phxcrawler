defmodule PhxCrawler.Repo.Migrations.Page do
  use Ecto.Migration

  def change do
    create table(:page) do
      add(:page_url, :text)
      add :chapter_id, references(:chapter)
    end

    create unique_index(:page, [:page_url,:chapter_id])
  end
end
