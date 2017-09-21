defmodule SignDict.List do
  use SignDict.Web, :model

  alias SignDict.Repo
  alias SignDict.ListEntry

  @types ["categorie-list"]
  @sort_orders ["manual", "alphabetical_desc", "alphabetical_asc"]

  schema "lists" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :sort_order, :string
    belongs_to :created_by, SignDict.User
    has_many :list_entries, SignDict.ListEntry
    has_many :entries, through: [:list_entries, :entry]

    timestamps()
  end

  def types, do: @types

  def sort_orders, do: @sort_orders

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def admin_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :type, :sort_order, :description])
    |> validate_required([:name, :type, :sort_order])
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:sort_order, @sort_orders)
  end

  def entries(%SignDict.List{id: id, sort_order: "manual"}) do
    from(entry in ListEntry, where: entry.list_id == ^id, order_by: :sort_order)
    |> Repo.all
    |> Repo.preload(entry: [:current_video])
  end
  def entries(%SignDict.List{id: id, sort_order: "alphabetical_asc"}) do
    from(list_entry in ListEntry,
         join: entry in assoc(list_entry, :entry),
         where: list_entry.list_id == ^id, order_by: entry.text)
    |> Repo.all
    |> Repo.preload(entry: [:current_video])
  end
  def entries(%SignDict.List{id: id, sort_order: "alphabetical_desc"}) do
    from(list_entry in ListEntry,
         join: entry in assoc(list_entry, :entry),
         where: list_entry.list_id == ^id, order_by: [desc: entry.text])
    |> Repo.all
    |> Repo.preload(entry: [:current_video])
  end

  # TODO:
  # * filter list entries without current video
  # * Paginate list entries
  # * Add method to move item up/down in sort order
end
