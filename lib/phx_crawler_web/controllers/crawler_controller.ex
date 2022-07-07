defmodule PhxCrawlerWeb.CrawlerController do
  use PhxCrawlerWeb, :controller

  def crawler(conn, params) do
    # conn
    render(conn, "crawler.html")
  end
end
