defmodule PhxCrawler.Crawler do
  import Ecto.Query, warn: false
  alias PhxCrawler.{Repo, Category, Story,StoryCategoryRel, Chapter, Page}

  def parse_pagination(records, page_number, per_page)do

    total_record = length(records)
    total_pages = ceil(total_record / per_page)
    pagination_size = 10
    sub_pagination_size = round(pagination_size/2)

    start_page = if total_pages > pagination_size do
        cond do
          page_number > total_pages - sub_pagination_size -> total_pages - pagination_size
          page_number > sub_pagination_size and page_number <= total_pages - sub_pagination_size
            -> page_number - sub_pagination_size

          true -> 1
        end
      else 1 end
    end_page = if total_pages > pagination_size do
        cond do
          page_number < (total_pages - sub_pagination_size) and page_number >= sub_pagination_size
            -> page_number + sub_pagination_size
          page_number < sub_pagination_size -> pagination_size
          true -> total_pages
        end
      else total_pages end


    list_page = Enum.to_list(start_page..end_page) |> Enum.map(fn x ->
      %{
        :name => x,
        :class => if x == page_number  do "pagination-link active" else "pagination-link" end
      }
    end)

    %{
      :total_pages => total_pages,
      :page_number => page_number,
      :list_page => list_page
    }
  end



  def list_category(params) do
    limit = params["per_page"] || nil
    page_number = params["page_number"] || 1
    offset = (page_number - 1) * (limit || 1)
    search_term = get_in(params, ["query"])
    Category
    |> Category.search(search_term, limit, offset)
    |> Repo.all()
  end


  def get_category!(id), do: Repo.get!(Category, id)


  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end


  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end


  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end


  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def list_story(params) do
    limit = params["per_page"] || nil
    page_number = params["page_number"] || 1
    offset = (page_number - 1) * (limit || 1)
    search_term = get_in(params, ["query"])
    Story
    |> Story.search(search_term, limit, offset)
    |> Repo.all()
  end


  def get_story!(id), do: Repo.get!(Story, id)


  def create_story(attrs \\ %{}) do
    %Story{}
    |> Story.changeset(attrs)
    |> Repo.insert()
  end


  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Repo.update()
  end


  def delete_story(%Story{} = story) do
    Repo.delete(story)
  end


  def change_story(%Story{} = story, attrs \\ %{}) do
    Story.changeset(story, attrs)
  end

  def get_story_by_category(params) do
    limit = params["per_page"] || nil
    page_number = params["page_number"] || 1
    offset = (page_number - 1) * (limit || 1)

    search_term = get_in(params, ["query"])
    category_id = String.to_integer(params["id"])
    wildcard_search = "%#{search_term}%"

    query = from s in Story,
      join: rel in StoryCategoryRel,
      on: rel.story_id == s.id,
      limit: ^limit,
      offset: ^offset,
      where: rel.category_id == ^category_id and ilike(s.name, ^wildcard_search),
      select: %{id: s.id, name: s.name, cover_image_url: s.cover_image_url}
    Repo.all(query)
  end

  def get_chapter_by_story(params) do
    limit = params["per_page"] || nil
    page_number = params["page_number"] || 1
    offset = (page_number - 1) * (limit || 1)

    story_id = String.to_integer(params["id"])
    query = from c in Chapter,
      join: s in Story,
      on: c.story_id == s.id,
      limit: ^limit,
      offset: ^offset,
      where: c.story_id == ^story_id,
      select: %{
        id: c.id,
        name: c.name,
        total_page: c.total_page,
        # story_id: c.story_id,
        # chapter_url: c.chapter_url
      }
    Repo.all(query)
  end

  def list_chapter do
    Repo.all(Chapter)
  end

  def get_chapter!(id), do: Repo.get!(Chapter, id)

  def create_chapter(attrs \\ %{}) do
    %Chapter{}
    |> Chapter.changeset(attrs)
    |> Repo.insert()
  end

  def update_chapter(%Chapter{} = chapter, attrs) do
    chapter
    |> Chapter.changeset(attrs)
    |> Repo.update()
  end

  def delete_chapter(%Chapter{} = chapter) do
    Repo.delete(chapter)
  end

  def change_chapter(%Chapter{} = chapter, attrs \\ %{}) do
    Chapter.changeset(chapter, attrs)
  end


  def get_page_by_chapter_id(params) do
    limit = params["per_page"] || nil
    page_number = params["page_number"] || 1
    offset = (page_number - 1) * (limit || 1)

    chapter_id = String.to_integer(params["id"])
    query = from p in Page,
      join: c in Chapter,
      on: p.chapter_id == c.id,
      limit: ^limit,
      offset: ^offset,
      where: p.chapter_id == ^chapter_id,
      select: %{
        id: p.id,
        page_url: p.page_url
      }
    Repo.all(query)
  end

  def list_page do
    Repo.all(Page)
  end

  def get_page!(id), do: Repo.get!(Page, id)

  def create_page(attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  def change_page(%Page{} = page, attrs \\ %{}) do
    Page.changeset(page, attrs)
  end
end
