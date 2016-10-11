defmodule ElasticSearch do
  @moduledoc false

  import Tirexs.Search

  @mix_env Mix.env
  defp environment_name() do
    case @mix_env do
      :prod -> "production"
      :dev -> "development"
      :test -> "test"
      _ -> "unknown"
    end
  end

  defp build_query(q, index) do
    search [index: index] do
        query do
          dis_max do
            queries do
              [
               match("_all", q, [boost: 10, operator: "and", analyzer: "searchkick_search"]),
               match("_all", q, [boost: 10, operator: "and", analyzer: "searchkick_search2"]),
               match("_all", q, [boost: 1, operator: "and", analyzer: "searchkick_search", fuzziness: 1, prefix_length: 0, max_expansions: 3, fuzzy_transpositions: true]),
               match("_all", q, [boost: 1, operator: "and", analyzer: "searchkick_search2", fuzziness: 1, prefix_length: 0, max_expansions: 3, fuzzy_transpositions: true])
               ]
            end
          end
        end
        highlight do
          [ pre_tags: ["<span class=app_search_word>"],
            post_tags: ["</span>"],
            fields: [
              "content.analyzed": [fragment_size: 80]
            ]
          ]
        end
      end
  end

  def articles(q) do
    index = "articles_#{environment_name()}"
    query = build_query(q, index)

    { :ok, 200, r } = Tirexs.Query.create_resource(query)
    hits = r[:hits][:hits]

    Enum.map(hits, fn(h) ->
      article = h[:_source]
      article_type = article.article_type
      url = case article_type do
        "text" -> "texts"
        "persona" -> "personalii"
        "thesaurus" -> "glossariy"
        _ -> "texts"
      end

      url = "http://app.papush.ru/#{url}/#{article.url}"
      parent_link = if (article_type == "persona"), do: "personas.html", else: "thesaurus.html"
      excerpts = ["", h[:highlight][:"content.analyzed"], ""] |> List.flatten |> Enum.join(" &#8230; ")

      article_type = case article_type do
        "persona" ->  "Персоналии"
        "thesaurus" -> "Глоссарий"
        "text" -> "Тексты"
      end

      %{ id: h[:_id],
        name: article.name,
        article_type: article_type,
        url: url,
        parent_link: parent_link,
        excerpts: excerpts
      }
    end)
  end

end