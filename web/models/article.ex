defmodule AppSearch.Article do
  use AppSearch.Web, :model

  schema "articles" do
    field :name, :string
    field :content, :string
    field :url, :string
    field :resource_id, :string
    field :resource_type, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
    field :article_type, :string
    field :source, :string
    field :result, :string
    field :metadata, :string
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :content, :url, :resource_id, :resource_type, :created_at, :updated_at, :article_type, :source, :result, :metadata])
    |> validate_required([:name, :content, :url, :resource_id, :resource_type, :created_at, :updated_at, :article_type, :source, :result, :metadata])
  end
end
