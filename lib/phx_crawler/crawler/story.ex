defmodule PhxCrawler.Story do
  import Ecto.Query, only: [from: 2]
  use Ecto.Schema
  import Ecto.Changeset

  schema "story" do
    field(:name, :string)
    field(:description, :string)
    field(:story_url, :string)
    field(:cover_image_url, :string)
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
      :story_url,
      :description,
      :cover_image_url,
      :author,
      :total_chapter,
      :status,
      :last_update
    ])
    |> Ecto.Changeset.unique_constraint(:story_url)
    |> cast_assoc(:category_ids, with: &PhxCrawler.Category.changeset/2, )
    # |> Ecto.Changeset.put_assoc(:category_ids, parse_category_ids(params))
  end

  # defp parse_category_ids(params)  do
  #   (params["category_ids"] || [])
  #   |> Enum.map(&get_or_insert_tag/1)
  # end

  # defp get_or_insert_tag(category) do
  #   Repo.get_by(PhxCrawler.Category, category_url: category.category_url) ||
  #     Repo.insert!(PhxCrawler.Category, %PhxCrawler.Category{
  #       category_url: category.category_url,
  #       name: category.name
  #     })
  # end

  def search(query, search_term, limit \\ nil, offset) do
    wildcard_search = "%#{search_term}%"

    from story in query,
    where: ilike(story.name, ^wildcard_search),
    limit: ^limit,
    offset: ^offset
  end
end
