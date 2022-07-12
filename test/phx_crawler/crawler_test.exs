defmodule PhxCrawler.CrawlerTest do
  use PhxCrawler.DataCase

  alias PhxCrawler.Crawler

  describe "story" do
    alias PhxCrawler.Crawler.Story

    import PhxCrawler.CrawlerFixtures

    @invalid_attrs %{name: nil}

    test "list_story/0 returns all story" do
      story = story_fixture()
      assert Crawler.list_story() == [story]
    end

    test "get_story!/1 returns the story with given id" do
      story = story_fixture()
      assert Crawler.get_story!(story.id) == story
    end

    test "create_story/1 with valid data creates a story" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Story{} = story} = Crawler.create_story(valid_attrs)
      assert story.name == "some name"
    end

    test "create_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawler.create_story(@invalid_attrs)
    end

    test "update_story/2 with valid data updates the story" do
      story = story_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Story{} = story} = Crawler.update_story(story, update_attrs)
      assert story.name == "some updated name"
    end

    test "update_story/2 with invalid data returns error changeset" do
      story = story_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawler.update_story(story, @invalid_attrs)
      assert story == Crawler.get_story!(story.id)
    end

    test "delete_story/1 deletes the story" do
      story = story_fixture()
      assert {:ok, %Story{}} = Crawler.delete_story(story)
      assert_raise Ecto.NoResultsError, fn -> Crawler.get_story!(story.id) end
    end

    test "change_story/1 returns a story changeset" do
      story = story_fixture()
      assert %Ecto.Changeset{} = Crawler.change_story(story)
    end
  end

  describe "category" do
    alias PhxCrawler.Crawler.Category

    import PhxCrawler.CrawlerFixtures

    @invalid_attrs %{name: nil}

    test "list_category/0 returns all category" do
      category = category_fixture()
      assert Crawler.list_category() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Crawler.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Category{} = category} = Crawler.create_category(valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawler.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Crawler.update_category(category, update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawler.update_category(category, @invalid_attrs)
      assert category == Crawler.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Crawler.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Crawler.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Crawler.change_category(category)
    end
  end

  describe "chapter" do
    alias PhxCrawler.Crawler.Chapter

    import PhxCrawler.CrawlerFixtures

    @invalid_attrs %{chapter_url: nil, name: nil, total_page: nil}

    test "list_chapter/0 returns all chapter" do
      chapter = chapter_fixture()
      assert Crawler.list_chapter() == [chapter]
    end

    test "get_chapter!/1 returns the chapter with given id" do
      chapter = chapter_fixture()
      assert Crawler.get_chapter!(chapter.id) == chapter
    end

    test "create_chapter/1 with valid data creates a chapter" do
      valid_attrs = %{chapter_url: "some chapter_url", name: "some name", total_page: 42}

      assert {:ok, %Chapter{} = chapter} = Crawler.create_chapter(valid_attrs)
      assert chapter.chapter_url == "some chapter_url"
      assert chapter.name == "some name"
      assert chapter.total_page == 42
    end

    test "create_chapter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawler.create_chapter(@invalid_attrs)
    end

    test "update_chapter/2 with valid data updates the chapter" do
      chapter = chapter_fixture()
      update_attrs = %{chapter_url: "some updated chapter_url", name: "some updated name", total_page: 43}

      assert {:ok, %Chapter{} = chapter} = Crawler.update_chapter(chapter, update_attrs)
      assert chapter.chapter_url == "some updated chapter_url"
      assert chapter.name == "some updated name"
      assert chapter.total_page == 43
    end

    test "update_chapter/2 with invalid data returns error changeset" do
      chapter = chapter_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawler.update_chapter(chapter, @invalid_attrs)
      assert chapter == Crawler.get_chapter!(chapter.id)
    end

    test "delete_chapter/1 deletes the chapter" do
      chapter = chapter_fixture()
      assert {:ok, %Chapter{}} = Crawler.delete_chapter(chapter)
      assert_raise Ecto.NoResultsError, fn -> Crawler.get_chapter!(chapter.id) end
    end

    test "change_chapter/1 returns a chapter changeset" do
      chapter = chapter_fixture()
      assert %Ecto.Changeset{} = Crawler.change_chapter(chapter)
    end
  end

  describe "page" do
    alias PhxCrawler.Crawler.Page

    import PhxCrawler.CrawlerFixtures

    @invalid_attrs %{name: nil}

    test "list_page/0 returns all page" do
      page = page_fixture()
      assert Crawler.list_page() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Crawler.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Page{} = page} = Crawler.create_page(valid_attrs)
      assert page.name == "some name"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crawler.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Page{} = page} = Crawler.update_page(page, update_attrs)
      assert page.name == "some updated name"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Crawler.update_page(page, @invalid_attrs)
      assert page == Crawler.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Crawler.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Crawler.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Crawler.change_page(page)
    end
  end
end
