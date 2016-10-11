defmodule AppSearch.Router do
  use AppSearch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
  end

  pipeline :api do
    plug TrailingFormatPlug
#    plug :accepts, ["json"]
  end

#  scope "/", AppSearch do
#    pipe_through :browser
#    get "/", PageController, :index
#  end

  scope "/", AppSearch do
    pipe_through :api

    resources "/articles/:q", ArticleController, only: [:index]
  end

end
