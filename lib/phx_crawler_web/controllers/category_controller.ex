defmodule PhxCrawlerWeb.CategoryController do
  use PhxCrawlerWeb, :controller

  alias PhxCrawler.{Crawler, Category, Repo}

  def index(conn, params) do
    per_page = 10
    page_number = (params["page"] || "1") |> String.to_integer()
    records = Crawler.list_category(params)
    params = Map.put_new(params, "per_page" , per_page)
    params = Map.put_new(params, "page_number" , page_number)

    category = Crawler.list_category(params)

    page_pagination = Crawler.parse_pagination(records, page_number, per_page)
    render(conn, "index.html", category: category, page_pagination: page_pagination)
  end

  # def new(conn, _params) do
  #   changeset = Crawler.change_category(%Category{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"category" => category_params}) do
  #   case Crawler.create_category(category_params) do
  #     {:ok, category} ->
  #       conn
  #       |> put_flash(:info, "Category created successfully.")
  #       |> redirect(to: Routes.category_path(conn, :show, category))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, params) do
    category = Crawler.get_category!(params["id"])

    per_page = 32
    page_number = (params["page"] || "1") |> String.to_integer()
    records = Crawler.get_story_by_category(params)
    params = Map.put_new(params, "per_page" , per_page)
    params = Map.put_new(params, "page_number" , page_number)

    stories = Crawler.get_story_by_category(params)

    page_pagination = Crawler.parse_pagination(records, page_number, per_page)

    render(conn, "show.html", category: category, stories: stories, page_pagination: page_pagination, category_id: params["id"])
  end

  def crawler(conn, _params) do
    render(conn, "crawler.html")
  end

  def valid_url(url)do
    uri = URI.parse(url)
    uri.scheme != nil && uri.host =~ "."
  end

  def crawler_action(conn, params) do
    foo = params["foo"]
    category_url = foo["category_url"]
    check_url = category_url |> valid_url
    if check_url do
      PhxCrawler.crawler_category(category_url)
      category_id = Repo.get_by(Category, category_url: category_url )
      conn
      |> put_flash(:info, "Crawler successfully.")
      |> redirect(to: Routes.category_path(conn, :show, category_id.id))
    else
      conn
      |> put_flash(:error, "Invalid url!")
      |> redirect(to: Routes.category_path(conn, :crawler))
    end
  end

end
