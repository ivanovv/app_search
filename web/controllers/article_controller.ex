defmodule AppSearch.ArticleController do
  use AppSearch.Web, :controller
  alias AppSearch.ElasticSearch

  def index(conn, %{"q" => q, "callback" => jsonp_callback}) do
    q = String.split(q, ".") |> List.first # человек.jsonp -> человек
    articles = ElasticSearch.articles(q)
    conn
    |> put_status(:ok)
    |> put_resp_header("Content-Type", "application/javascript")
    |> text("/**/#{jsonp_callback}(#{Poison.encode!(articles)})")
  end

end
