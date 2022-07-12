defmodule PhxCrawler.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapter" do
    field(:name, :string)
    field(:total_page, :integer)
    field(:chapter_url, :string)
    belongs_to(:story, PhxCrawler.Story)
  end

  def changeset(chapter, params \\ %{}) do
    chapter
      |> cast(params,[:name, :total_page, :chapter_url, :story_id])
      |> Ecto.Changeset.unique_constraint(:chapter_url)
  end
end
