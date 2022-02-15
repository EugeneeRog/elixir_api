defmodule Cars.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false, unique: true

      timestamps()
    end

      create(
        unique_index(
          :brands ,
          [:name],
          name: :index_for_brands_name
        )
      )
  end
end


