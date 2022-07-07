defmodule PhxCrawler.Repo.Migrations.Page do
  use Ecto.Migration

  def change do
    create table(:page) do
      add(:name, :string, unique: true)
      add(:url_img, :string)
      add :chapter_id, references(:chapter)
    end
  end
end
