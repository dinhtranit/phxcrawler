defmodule PhxCrawler.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "page" do
    field(:page_url, :string)
    belongs_to(:chapter, PhxCrawler.Chapter)
  end

  def changeset(chapter, params \\ %{}) do
    chapter
      |> cast(params,[:page_url, :chapter])
      |> Ecto.Changeset.unique_constraint(:page_url)
      |> Ecto.Changeset.unique_constraint(:chapter)
  end
end
