defmodule AppSearch do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(AppSearch.Repo, []),
      supervisor(AppSearch.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: AppSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    AppSearch.Endpoint.config_change(changed, removed)
    :ok
  end
end
