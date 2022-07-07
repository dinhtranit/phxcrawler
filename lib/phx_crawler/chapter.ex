defmodule PhxCrawler.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapter" do
    field(:name, :string)
    field(:total_page, :integer)
    belongs_to(:story, PhxCrawler.Story)
  end

  def changeset(chapter, params \\ %{}) do
    chapter
      |> cast(params,[:name,:total_page, :story_id])
      # |> cast_assoc(:story_id)
  end
end
