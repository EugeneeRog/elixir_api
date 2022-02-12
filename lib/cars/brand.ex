defmodule Cars.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "brands" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def add_brand(%{
    "name" => name})
    do
    Cars.Repo.insert!(%Cars.Brand{
      name: name
    })
  end
end
