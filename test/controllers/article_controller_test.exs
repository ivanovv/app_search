defmodule AppSearch.ArticleControllerTest do
  use AppSearch.ConnCase

  alias AppSearch.Article
  @valid_attrs %{article_type: "some content", content: "some content", created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, metadata: "some content", name: "some content", resource_id: "some content", resource_type: "some content", result: "some content", source: "some content", updated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, url: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    article = Repo.insert! %Article{}
    conn = get conn, article_path(conn, :show, article)
    assert json_response(conn, 200)["data"] == %{"id" => article.id,
      "name" => article.name,
      "content" => article.content,
      "url" => article.url,
      "resource_id" => article.resource_id,
      "resource_type" => article.resource_type,
      "created_at" => article.created_at,
      "updated_at" => article.updated_at,
      "article_type" => article.article_type,
      "source" => article.source,
      "result" => article.result,
      "metadata" => article.metadata}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Article, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    article = Repo.insert! %Article{}
    conn = put conn, article_path(conn, :update, article), article: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Article, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article = Repo.insert! %Article{}
    conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    article = Repo.insert! %Article{}
    conn = delete conn, article_path(conn, :delete, article)
    assert response(conn, 204)
    refute Repo.get(Article, article.id)
  end
end
