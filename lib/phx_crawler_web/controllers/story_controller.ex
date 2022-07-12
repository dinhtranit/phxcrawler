defmodule PhxCrawlerWeb.StoryController do
  use PhxCrawlerWeb, :controller
  alias PhxCrawler.{Crawler, Story}

  def index(conn, params) do
    per_page = 10
    page_number = (params["page"] || "1") |> String.to_integer()
    records = Crawler.list_story(params)
    params = Map.put_new(params, "per_page" , per_page)
    params = Map.put_new(params, "page_number" , page_number)
    story = Crawler.list_story(params)

    page_pagination = Crawler.parse_pagination(records, page_number, per_page)
    render(conn, "index.html", story: story, page_pagination: page_pagination)
  end

  def new(conn, _params) do
    changeset = Crawler.change_story(%Story{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"story" => story_params}) do
    case Crawler.create_story(story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story created successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    id = params["id"]
    story = Crawler.get_story!(id)
    per_page = 20
    page_number = (params["page"] || "1") |> String.to_integer()
    records = Crawler.get_chapter_by_story(params)
    params = Map.put_new(params, "per_page" , per_page)
    params = Map.put_new(params, "page_number" , page_number)

    chapter = Crawler.get_chapter_by_story(params)
    page_pagination = Crawler.parse_pagination(records, page_number, per_page)
    render(conn, "show.html", story: story, chapter: chapter, page_pagination: page_pagination, story_id: params["id"])
  end

  def edit(conn, %{"id" => id}) do
    story = Crawler.get_story!(id)
    changeset = Crawler.change_story(story)
    render(conn, "edit.html", story: story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "story" => story_params}) do
    story = Crawler.get_story!(id)

    case Crawler.update_story(story, story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story updated successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", story: story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    story = Crawler.get_story!(id)
    {:ok, _story} = Crawler.delete_story(story)
    conn
    |> put_flash(:info, "Story deleted successfully.")
    |> redirect(to: Routes.story_path(conn, :index))
  end
end
