defmodule PhxCrawler.Repo.Migrations.Chapter do
  use Ecto.Migration

  def change do
    create table(:chapter) do
      add(:name, :string, unique: true)
      add(:total_page, :integer)
      add :story_id, references(:story)
    end
  end
end
