defmodule PhxCrawler.Repo.Migrations.Story do
  use Ecto.Migration

  def change do
    create table(:story) do
      add(:name, :string)
      add(:story_url, :text, null: false)
      add(:description, :text)
      add(:cover_image_url, :text)
      add(:author, :string)
      add(:status, :string)
      add(:total_chapter, :integer)
      add(:last_update, :date)
    end

    create unique_index(:story, [:story_url])
  end
end
