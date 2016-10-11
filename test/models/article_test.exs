defmodule AppSearch.ArticleTest do
  use AppSearch.ModelCase

  alias AppSearch.Article

  @valid_attrs %{article_type: "some content", content: "some content", created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, metadata: "some content", name: "some content", resource_id: "some content", resource_type: "some content", result: "some content", source: "some content", updated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end
end
