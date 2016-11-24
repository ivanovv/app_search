defmodule AppSearch.Router do
  use AppSearch.Web, :router

  pipeline :api do
    plug TrailingFormatPlug
#    plug :accepts, ["json"]
  end

  scope "/", AppSearch do
    pipe_through :api

    resources "/articles/:q", ArticleController, only: [:index]
  end

end
