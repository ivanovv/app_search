defmodule AppSearch.ArticleView do
  use AppSearch.Web, :view

  def render("index.json", %{articles: articles}) do
    render_many(articles, AppSearch.ArticleView, "article.json")
  end

  def render("show.json", %{article: article}) do
    render_one(article, AppSearch.ArticleView, "article.json")
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      name: article.name,
      url: article.url,
      article_type: article.article_type,
      parent_link: article.parent_link,
      excerpts: article.excerpts
      }
  end
end
