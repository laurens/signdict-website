defmodule SignDict.ListTest do
  use SignDict.ModelCase

  import SignDict.Factory

  alias SignDict.List

  @valid_attrs %{
    name: "some content", description: "some description",
    sort_order: "manual", type: "categorie-list"
  }
  @invalid_attrs %{}

  describe "admin_changeset" do
    test "admin_changeset with valid attributes" do
      changeset = List.admin_changeset(%List{}, @valid_attrs)
      assert changeset.valid?
    end

    test "admin_changeset with invalid attributes" do
      changeset = List.admin_changeset(%List{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "entries/1" do
    test "returns list entries in order of their sort id" do
      list = insert :list, sort_order: "manual"
      entry_without_video = insert :entry, text: "Remove Me"
      list_entry_1 = insert :list_entry, list: list, sort_order: 2
      list_entry_2 = insert :list_entry, list: list, sort_order: 3
      list_entry_3 = insert :list_entry, list: list, sort_order: 1
      insert :list_entry, list: list, sort_order: 4, entry: entry_without_video

      assert Enum.map(List.entries(list), &(&1.id)) == [list_entry_3.id, list_entry_1.id, list_entry_2.id]
    end

    test "returns list entries in alphabetical order" do
      list = insert :list, sort_order: "alphabetical_asc"
      entry_1 = insert :entry_with_current_video, text: "Cherry"
      entry_2 = insert :entry_with_current_video, text: "Banana"
      entry_3 = insert :entry_with_current_video, text: "Apple"
      entry_4 = insert :entry, text: "Remove Me"
      list_entry_1 = insert :list_entry, list: list, sort_order: 1, entry: entry_1
      list_entry_2 = insert :list_entry, list: list, sort_order: 2, entry: entry_2
      list_entry_3 = insert :list_entry, list: list, sort_order: 3, entry: entry_3
      insert :list_entry, list: list, sort_order: 4, entry: entry_4

      assert Enum.map(List.entries(list), &(&1.id)) == [list_entry_3.id, list_entry_2.id, list_entry_1.id]
    end

    test "returns list entries in reversed alphabetical order" do
      list = insert :list, sort_order: "alphabetical_desc"
      entry_1 = insert :entry_with_current_video, text: "Cherry"
      entry_2 = insert :entry_with_current_video, text: "Banana"
      entry_3 = insert :entry_with_current_video, text: "Apple"
      entry_4 = insert :entry, text: "Remove Me"
      list_entry_1 = insert :list_entry, list: list, sort_order: 1, entry: entry_1
      list_entry_2 = insert :list_entry, list: list, sort_order: 2, entry: entry_2
      list_entry_3 = insert :list_entry, list: list, sort_order: 3, entry: entry_3
      insert :list_entry, list: list, sort_order: 4, entry: entry_4

      assert Enum.map(List.entries(list), &(&1.id)) == [list_entry_1.id, list_entry_2.id, list_entry_3.id]
    end
  end

end
