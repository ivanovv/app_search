defmodule AppSearch.ElasticSearch do

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

    { :ok, 200, result } = Tirexs.Query.create_resource(query)
    hits = result[:hits][:hits]
    Enum.map(hits, &(extract_hit &1))
  end


  @russian_article_types %{ "persona" => "Персоналии", "thesaurus" => "Глоссарий", "text" => "Тексты" }
  @folders %{ "text" => "texts", "persona" => "personalii", "thesaurus" => "glossariy" }

  defp extract_hit(%{_id: id, _source: article, highlight: highlight} ) do
    %{article_type: type, name: name, url: url} = article
    folder = Map.get(@folders, type, "texts")

    full_url = "http://app.papush.ru/#{folder}/#{url}"
    parent_link = if (type == "persona"), do: "personas.html", else: "thesaurus.html"
    excerpts = ["", highlight[:"content.analyzed"], ""] |> List.flatten |> Enum.join(" &#8230; ")
    article_type = Map.get(@russian_article_types, type)

    %{ id: id,
      name: name,
      article_type: article_type,
      url: full_url,
      parent_link: parent_link,
      excerpts: excerpts
    }
  end

end