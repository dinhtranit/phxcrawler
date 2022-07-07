defmodule PhxCrawler.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "page" do
    field(:name, :string)
    field(:url_img, :string)
    belongs_to(:chapter, PhxCrawler.Chapter)
  end

  def changeset(chapter, params \\ %{}) do
    chapter
      |> cast(params,[:name,:url_img, :chapter_id])
  end
end
