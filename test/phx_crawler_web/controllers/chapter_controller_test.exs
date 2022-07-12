defmodule PhxCrawlerWeb.ChapterControllerTest do
  use PhxCrawlerWeb.ConnCase

  import PhxCrawler.CrawlerFixtures

  @create_attrs %{chapter_url: "some chapter_url", name: "some name", total_page: 42}
  @update_attrs %{chapter_url: "some updated chapter_url", name: "some updated name", total_page: 43}
  @invalid_attrs %{chapter_url: nil, name: nil, total_page: nil}

  describe "index" do
    test "lists all chapter", %{conn: conn} do
      conn = get(conn, Routes.chapter_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Chapter"
    end
  end

  describe "new chapter" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.chapter_path(conn, :new))
      assert html_response(conn, 200) =~ "New Chapter"
    end
  end

  describe "create chapter" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.chapter_path(conn, :create), chapter: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.chapter_path(conn, :show, id)

      conn = get(conn, Routes.chapter_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Chapter"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.chapter_path(conn, :create), chapter: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Chapter"
    end
  end

  describe "edit chapter" do
    setup [:create_chapter]

    test "renders form for editing chosen chapter", %{conn: conn, chapter: chapter} do
      conn = get(conn, Routes.chapter_path(conn, :edit, chapter))
      assert html_response(conn, 200) =~ "Edit Chapter"
    end
  end

  describe "update chapter" do
    setup [:create_chapter]

    test "redirects when data is valid", %{conn: conn, chapter: chapter} do
      conn = put(conn, Routes.chapter_path(conn, :update, chapter), chapter: @update_attrs)
      assert redirected_to(conn) == Routes.chapter_path(conn, :show, chapter)

      conn = get(conn, Routes.chapter_path(conn, :show, chapter))
      assert html_response(conn, 200) =~ "some updated chapter_url"
    end

    test "renders errors when data is invalid", %{conn: conn, chapter: chapter} do
      conn = put(conn, Routes.chapter_path(conn, :update, chapter), chapter: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Chapter"
    end
  end

  describe "delete chapter" do
    setup [:create_chapter]

    test "deletes chosen chapter", %{conn: conn, chapter: chapter} do
      conn = delete(conn, Routes.chapter_path(conn, :delete, chapter))
      assert redirected_to(conn) == Routes.chapter_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.chapter_path(conn, :show, chapter))
      end
    end
  end

  defp create_chapter(_) do
    chapter = chapter_fixture()
    %{chapter: chapter}
  end
end
