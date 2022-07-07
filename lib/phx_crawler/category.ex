defmodule PhxCrawler.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "category" do
    field(:name, :string)
  end

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, [:name])
  end
end
