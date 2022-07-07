defmodule PhxCrawler.Story do
  use Ecto.Schema
  import Ecto.Changeset

  schema "story" do
    field(:name, :string)
    field(:description, :string)
    field(:cover_image, :string)
    many_to_many(:category_ids, PhxCrawler.Category, join_through: "story_category_rel")
    field(:author, :string)
    field(:status, :string)
    field(:total_chapter, :integer)
    field(:last_update, :date)
  end

  def changeset(story, params \\ %{}) do
    story
    |> cast(params, [
      :name,
      :description,
      :cover_image,
      :author,
      :total_chapter,
      :status,
      :last_update
    ])
    |> cast_assoc(:category_ids, with: &PhxCrawler.Category.changeset/2, )
  end
end
