defmodule PhxCrawlerWeb.ChapterController do
  use PhxCrawlerWeb, :controller

  alias PhxCrawler.{Crawler, Chapter}

  def index(conn, _params) do
    chapter = Crawler.list_chapter()
    render(conn, "index.html", chapter: chapter)
  end

  def new(conn, _params) do
    changeset = Crawler.change_chapter(%Chapter{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"chapter" => chapter_params}) do
    case Crawler.create_chapter(chapter_params) do
      {:ok, chapter} ->
        conn
        |> put_flash(:info, "Chapter created successfully.")
        |> redirect(to: Routes.chapter_path(conn, :show, chapter))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    id = params["id"]
    chapter = Crawler.get_chapter!(id)
    per_page = 50
    page_number = (params["page"] || "1") |> String.to_integer()
    records = Crawler.get_page_by_chapter_id(params)
    params = Map.put_new(params, "per_page" , per_page)
    params = Map.put_new(params, "page_number" , page_number)
    pages = Crawler.get_page_by_chapter_id(params)
    page_pagination = Crawler.parse_pagination(records, page_number, per_page)

    per_page = 10
    page_number = (params["page"] || "1") |> String.to_integer()
    params = Map.put_new(params, "per_page" , per_page)
    params = Map.put_new(params, "page_number" , page_number)

    chapters = Crawler.get_chapter_by_story(params)


    render(conn, "show.html", chapter: chapter, chapters: chapters, pages: pages,  page_pagination: page_pagination)
  end

  def edit(conn, %{"id" => id}) do
    chapter = Crawler.get_chapter!(id)
    changeset = Crawler.change_chapter(chapter)
    render(conn, "edit.html", chapter: chapter, changeset: changeset)
  end

  def update(conn, %{"id" => id, "chapter" => chapter_params}) do
    chapter = Crawler.get_chapter!(id)

    case Crawler.update_chapter(chapter, chapter_params) do
      {:ok, chapter} ->
        conn
        |> put_flash(:info, "Chapter updated successfully.")
        |> redirect(to: Routes.chapter_path(conn, :show, chapter))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", chapter: chapter, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chapter = Crawler.get_chapter!(id)
    {:ok, _chapter} = Crawler.delete_chapter(chapter)

    conn
    |> put_flash(:info, "Chapter deleted successfully.")
    |> redirect(to: Routes.chapter_path(conn, :index))
  end
end
