defmodule PhxCrawler.StoryCategoryRel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "story_category_rel" do
    field :story_id, :id
    field :category_id, :id
  end

  def changeset(story_category, params \\ %{}) do
    story_category
      |> cast(params,[:story_id, :category_id ])
      |> Ecto.Changeset.unique_constraint([:story_id,:category_id])

  end
end
