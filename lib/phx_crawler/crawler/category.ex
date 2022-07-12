defmodule PhxCrawler.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  schema "category" do
    field :name, :string
    field :category_url, :string
  end

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, [:name, :category_url])
    |> Ecto.Changeset.unique_constraint(:category_url)
  end

  def search(query, search_term, limit \\ nil, offset) do
    wildcard_search = "%#{search_term}%"

    from category in query,
    where: ilike(category.name, ^wildcard_search),
    limit: ^limit,
    offset: ^offset
  end
end
