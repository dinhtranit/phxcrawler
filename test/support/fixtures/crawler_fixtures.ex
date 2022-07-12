defmodule PhxCrawler.CrawlerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxCrawler.Crawler` context.
  """

  @doc """
  Generate a story.
  """
  def story_fixture(attrs \\ %{}) do
    {:ok, story} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PhxCrawler.Crawler.create_story()

    story
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PhxCrawler.Crawler.create_category()

    category
  end

  @doc """
  Generate a chapter.
  """
  def chapter_fixture(attrs \\ %{}) do
    {:ok, chapter} =
      attrs
      |> Enum.into(%{
        chapter_url: "some chapter_url",
        name: "some name",
        total_page: 42
      })
      |> PhxCrawler.Crawler.create_chapter()

    chapter
  end

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PhxCrawler.Crawler.create_page()

    page
  end
end
