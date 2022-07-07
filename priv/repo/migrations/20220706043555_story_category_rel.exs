defmodule PhxCrawler.Repo.Migrations.StoryCategoryRel do
  use Ecto.Migration

  def change do
    create table("story_category_rel", primary_key: false) do
      add :story_id, references(:story)
      add :category_id, references(:category)
    end
  end
end
