defmodule PhxCrawler.Repo.Migrations.Story do
  use Ecto.Migration

  def change do
    create table(:story) do
      add(:name, :string, unique: true)
      add(:description, :string)
      add(:cover_image, :string)
      add(:author, :string)
      add(:status, :string)
      add(:total_chapter, :integer)
      add(:last_update, :date)
    end
  end
end
