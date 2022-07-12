# defmodule PhxCrawler do
#   import Ecto.Query, only: [from: 2]
#   alias PhxCrawler.{Repo, Category, Story, Chapter, Page,StoryCategory}

#   def run do
#     crawler_story("https://www.medoctruyentranh.net/truyen-tranh/hoang-hau-ban-lam-55613845")
#     # crawler_category("https://www.medoctruyentranh.net/tim-truyen/cooking")
#   end

#   def crawler_category(url, storie \\ []) do
#     referer = "#{URI.parse(url).scheme}://#{URI.parse(url).host}/"
#     headers = [{"Referer", referer}]
#     document =  fetch_page(url, headers)

#     story_url_list = document |> Floki.find(".classifyList a") |> Floki.attribute("href")

#     story_ids = story_url_list |> Enum.map(fn story_url -> crawler_story(story_url) end)

#     # Crawler next page
#     page_list = document |> Floki.find(".page_floor a") |> Floki.attribute("href")
#     page_list = page_list |> Enum.map( fn x -> x
#         |> String.trim("?is_updating=")
#         |> String.trim("?is_updating=1")
#         |> String.trim("?is_updating=0")
#       end)
#     {first_page, page_list} = page_list |> List.pop_at(0)
#     {last_page, page_list} = page_list |> List.pop_at(-1)
#     storie = [storie | story_ids]
#     if last_page != url do
#       next_url = get_next_url(page_list, url)
#       crawler_category(next_url, storie)
#     end
#   end

#   def get_next_url([], _url) , do: nil

#   def get_next_url([next_url | page_list], url) do
#     if next_url != url do
#       get_next_url(page_list, url)
#     else
#       [next_url | page_list] = page_list
#       next_url
#     end
#   end

#   def crawler_story(url) do
#     referer = "#{URI.parse(url).scheme}://#{URI.parse(url).host}/"
#     headers = [{"Referer", referer}]
#     document =  fetch_page(url, headers)
#     # category_ids = insert_category(document)
#     categories = Floki.find(document, ".other_infos a")
#       |> Enum.map(fn x ->create_category( %{
#             category_url: Floki.attribute(x, "href") |> List.first(),
#             name: Floki.attribute(x, "title") |> List.first(),
#           })
#         end)
#     attrs_story = parse_story(url, document)
#     story_id = create_story(attrs_story)
#     create_sroty_category_rel(story_id, categories)

#     # document
#     #   |> Floki.find(".chapters")
#     #   |> Floki.find(".chapter_pages")
#     #   |> Floki.find("a") |>  Enum.each(fn x -> x
#     #     |> get_chapters(headers,story_id.id)
#     #   end)

#     story_id
#   end

#   def insert_story_category_rel(story_id, categories) do
#     categories |> Enum.each(fn category ->
#       # %StoryCategory{}
#       # |> StoryCategory.changeset(%{
#       #   story_id: story_id,
#       #   category_id:
#       # })
#       # |> Repo.insert()
#     end)
#     story_id
#   end

#   def create_sroty_category_rel(story_id, categories) do
#     categories |> Enum.each(fn category ->
#       %StoryCategory{}
#       |> StoryCategory.changeset(%{
#           story_id: story_id.id,
#           category_id: category.id
#         })
#       |> Repo.insert()
#     end)
#   end

#   def fetch_page(url,headers)do
#     response = HTTPoison.get!(url,headers)
#     case response do
#         {:error, result} ->  "Not Connect!!!"
#         _ -> response
#     end
#     result = Floki.parse_document(response.body)
#     case result do
#       {:ok, document} -> document
#       _ -> raise ("Data not valid!!!")
#     end
#   end

#   def parse_story(url, document)do
#     title = Floki.find(document, "#title") |> Floki.text()
#     description = document
#       |> Floki.find(".detail_infos .summary")
#       |> Floki.text()
#     image_conver = document
#       |> Floki.find(".detail_info img")
#       |> Floki.attribute("src")|> List.first()
#     author = document
#       |> Floki.find(".other_infos")|> List.first()
#       |> Floki.find("font")|> List.first()|> Floki.text()
#     status = document
#       |> Floki.find(".other_infos")|> Enum.at(1)
#       |> Floki.find("font")|> Floki.text()
#     {:ok, last_update} = document
#       |> Floki.find(".detail_con .detail .chapter_con .chapter_title span")
#       |> Enum.at(1)|> Floki.text()|> String.split()|> List.last()
#       |> String.replace("）", "")|> String.split("/")
#       |> Enum.map(&String.to_integer/1)
#       |> (fn [day, month, year] -> Date.new(year, month, day) end).()
#     total_chapter = document
#       |> Floki.find(".chapters")|> Floki.find(".chapter_pages")
#       |> Floki.find("a")|> length()

#     %{
#       story_url: url,
#       name: title,
#       description: description,
#       cover_image_url: image_conver,
#       author: author,
#       status: status,
#       last_update: last_update,
#       total_chapter: total_chapter,
#     }
#   end

#   def create_category(attrs \\ %{}) do
#     category_url = attrs[:category_url]
#     query = from c in "category",
#       limit: 1,
#       where: c.category_url == ^category_url,
#       select: c.id
#     exist = Repo.all(query)

#     if exist == [] do
#       result = %Category{}
#       |> Category.changeset(attrs)
#       |> Repo.insert()
#       case result do
#         {:ok, inserted} -> inserted
#         {:error, _} -> nil
#       end
#     else
#       List.first(exist)
#     end

#     # case result do
#     #     {:ok, inserted} -> inserted
#     #     {:error, _} -> nil
#     # end
#   end

#   def create_story(attrs \\ %{}) do
#     story_url = attrs[:story_url]
#     query = from c in "story",
#       limit: 1,
#       where: c.story_url == ^story_url,
#       select: c.id
#     exist = Repo.all(query)

#     if exist == [] do
#       result = %Story{}
#       |> Story.changeset(attrs)
#       |> Repo.insert()
#       case result do
#         {:ok, inserted} -> inserted
#         {:error, _} -> nil
#       end
#     else
#       List.first(exist)
#     end

#     # result = Repo.get_by(Story, story_url: attrs[:story_url]) || %Story{}
#     # |> Story.changeset(attrs)
#     # |> Repo.insert()

#     # end
#   end



#   def get_chapters(data_chapter, headers, story_id) do
#     if data_chapter do
#       chapter_url = data_chapter |> Floki.attribute("href") |> List.first()
#       document =  fetch_page(chapter_url, headers)

#       detail_item = document |> Floki.find("script#__NEXT_DATA__")
#         |> List.first()
#         |> Tuple.to_list()
#         |> Enum.at(2)
#         |> List.first()
#         |> Jason.decode!()
#         |> Map.get("props")
#         |> Map.get("pageProps")
#         |> Map.get("initialState")
#         |> Map.get("read")
#         |> Map.get("detail_item")


#       chapter_title = detail_item |> Map.get("chapter_title")

#       url_pages = detail_item
#         |> Map.get("elements")
#         |> Enum.map(fn x -> x |> Map.get("content") end)
#       total_page = length(url_pages)

#       chapter_id = insert_chapter(chapter_url, chapter_title, total_page, story_id)

#       insert_page(url_pages, chapter_id)
#     end
#   end

#   def insert_chapter(chapter_url, chapter_title, total_page, story_id) do
#     changeset = Chapter.changeset(%Chapter{}, %{
#       chapter_url: chapter_url,
#       name: chapter_title,
#       total_page: total_page,
#       story_id: story_id
#     })
#     result = Repo.insert(changeset)
#     case result do
#       {:ok, inserted} -> inserted.id
#       {:error, _} ->  Repo.get_by(Chapter, chapter_url: chapter_url).id
#     end
#   end

#   def insert_page(url_pages, chapter_id)do
#     page_data = url_pages |> Enum.map(fn x -> if(x != "", do: %{page_url: x, chapter_id: chapter_id})  end)
#     Repo.insert_all(Page, page_data, on_conflict: :nothing)
#   end
# end
