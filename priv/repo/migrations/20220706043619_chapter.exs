defmodule PhxCrawler.Repo.Migrations.Chapter do
  use Ecto.Migration

  def change do
    create table(:chapter) do
      add(:name, :string, unique: true)
      add(:total_page, :integer)
      add(:chapter_url, :text)
      add :story_id, references(:story)
    end
    create unique_index(:chapter, [:chapter_url])
  end
end
