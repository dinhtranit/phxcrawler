defmodule PhxCrawler do
  import Ecto.Query, only: [from: 2]
  alias PhxCrawler.{Repo, Category, Story, Chapter, Page}

  def filter_order_by("name_desc"), do: [desc: :name]
  def filter_order_by("name"),      do: [asc: :name]
  def filter_order_by(_),                   do: []

  def query()do
    query =
      from(
        c in Chapter,
        where: c.story_id >= 1,
        select: c.name,
        order_by: ^filter_order_by("name")
      )
    Repo.all(query)
  end

  def run do
    download("https://www.medoctruyentranh.net/truyen-tranh/kingdom-vuong-gia-thien-ha-58664")
  end

  def download(url) do
    referen = "#{URI.parse(url).scheme}://#{URI.parse(url).host}/"
    headers = [{"Referen", referen}]
    response = HTTPoison.get!(url,headers)
    case response do
        {:error, result} -> IO.inspect(result, label:  "Not Connect!!!")
        _ -> "OK"
    end
    {:ok, document} = Floki.parse_document(response.body)
    story_id = set_story(document)

    document
      |> Floki.find(".chapters")
      |> Floki.find(".chapter_pages")
      |> Floki.find("a") |>  Enum.each(fn x -> x
        |> get_chapters(headers, story_id)
      end)
  end

  def set_category(category) do
    if category != "" do
      query = from c in "category",
        limit: 1,
        where: c.name == ^category,
        select: c.id
      exist = Repo.all(query)

      if exist == [] do
        {:ok, inserted} = Repo.insert %Category{name: category}
        %{id: inserted.id}
      else
        %{ id: List.first(exist)}
      end
    end
  end

  def set_story(document)do
    title = Floki.find(document, "#title") |> Floki.text()
    description = document
      |> Floki.find(".detail_infos .summary")
      |> Floki.text()
    image_conver = document
      |> Floki.find(".detail_info img")
      |> Floki.attribute("src")
      |> List.first()
    author = document
      |> Floki.find(".other_infos")
      |> List.first()
      |> Floki.find("font")
      |> List.first()
      |> Floki.text()
    status = document
      |> Floki.find(".other_infos")
      |> Enum.at(1)
      |> Floki.find("font")
      |> Floki.text()
    {:ok, last_update} = document
      |> Floki.find(".detail_con .detail .chapter_con .chapter_title span")
      |> Enum.at(1)
      |> Floki.text()
      |> String.split()
      |> List.last()
      |> String.replace("）", "")
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)
      |> (fn [day, month, year] -> Date.new(year, month, day) end).()
    total_chapter = document
      |> Floki.find(".chapters")
      |> Floki.find(".chapter_pages")
      |> Floki.find("a")
      |> length()

    category_ids = Floki.find(document, ".other_infos a")
      |> Enum.map(fn x -> x |> Floki.attribute("title")
        |> List.first()
        |> set_category()
      end)
    query = from c in "story",
      limit: 1,
      where: c.name == ^title,
      select: c.id
    exist = Repo.all(query)
    if exist == [] do
      changeset = Story.changeset(%Story{}, %{
        name: title,
        description: description,
        cover_image: image_conver,
        category_ids: category_ids,
        author: author,
        status: status,
        last_update: last_update,
        total_chapter: total_chapter,
      })
      {:ok, inserted} = Repo.insert(changeset)
      inserted.id
    else
      List.first(exist)
    end
  end

  def get_chapters(data_chapter, headers, story_id) do
    if data_chapter do
      url = data_chapter
        |> Floki.attribute("href")
        |> List.first()
      get_story_pages(url, headers, story_id)
    end
  end

  def set_chapter(chapter_title, total_page, story_id) do
    query = from c in "chapter",
      limit: 1,
      where: c.name == ^chapter_title and c.story_id == ^story_id,
      select: c.id
    exist = Repo.all(query)

    if exist == [] do
      changeset = Chapter.changeset(%Chapter{}, %{
        name: chapter_title,
        total_page: total_page,
        story_id: story_id,
      })
      {:ok, inserted} = Repo.insert(changeset)
      {:ok, inserted.id}
    else
      {:ok, List.first(exist)}
    end
  end

  def get_story_pages(url, headers, story_id) do
    response = HTTPoison.get!(url,headers)
    {:ok, document} = Floki.parse_document(response.body)

    detail_item = document |> Floki.find("script#__NEXT_DATA__")
      |> List.first()
      |> Tuple.to_list()
      |> Enum.at(2)
      |> List.first()
      |> Jason.decode!()
      |> Map.get("props")
      |> Map.get("pageProps")
      |> Map.get("initialState")
      |> Map.get("read")
      |> Map.get("detail_item")

    chapter_title = detail_item |> Map.get("chapter_title")

    url_pages = detail_item
      |> Map.get("elements")
      |> Enum.map(fn x -> x |> Map.get("content") end)
    total_page = length(url_pages)

    {:ok, chapter_id} = set_chapter(chapter_title, total_page, story_id)
    download_story_page_img(url_pages, chapter_id, 0)
  end

  def download_story_page_img([], _chapter_id, _page_num), do: nil

  def download_story_page_img([url | url_pages], chapter_id, page_num) do
    page_name = to_string(page_num+1)
    query = from p in "page",
      limit: 1,
      where: p.name == ^page_name and p.chapter_id == ^chapter_id,
      select: p.id
    exist = Repo.all(query)

    if exist == [] do
      changeset = Page.changeset(%Page{}, %{
        name: page_name,
        url_img: url,
        chapter_id: chapter_id,
      })
      Repo.insert(changeset)
    end
    download_story_page_img(url_pages, chapter_id, page_num + 1)
  end
end
