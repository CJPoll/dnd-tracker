defmodule DndTrackerWeb.EnemyControllerTest do
  use DndTrackerWeb.ConnCase

  import DndTracker.EncountersFixtures

  alias DndTracker.Campaigns

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup do
    {:ok, campaign} = Campaigns.create_campaign(%{name: "test campaign"})
    {:ok, %{campaign: campaign}}
  end

  describe "index" do
    test "lists all enemies", %{conn: conn, campaign: campaign} do
      conn = get(conn, Routes.enemy_path(conn, :index, campaign.id))
      assert html_response(conn, 200) =~ "Listing Enemies"
    end
  end

  describe "new enemy" do
    test "renders form", %{conn: conn, campaign: campaign} do
      conn = get(conn, Routes.enemy_path(conn, :new, campaign.id))
      assert html_response(conn, 200) =~ "New Enemy"
    end
  end

  describe "create enemy" do
    test "redirects to show when data is valid", %{conn: conn, campaign: campaign} do
      conn = post(conn, Routes.enemy_path(conn, :create, campaign.id), enemy: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.enemy_path(conn, :show, id)

      conn = get(conn, Routes.enemy_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Enemy"
    end

    test "renders errors when data is invalid", %{conn: conn, campaign: campaign} do
      conn = post(conn, Routes.enemy_path(conn, :create, campaign.id), enemy: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Enemy"
    end
  end

  describe "edit enemy" do
    setup [:create_enemy]

    test "renders form for editing chosen enemy", %{conn: conn, enemy: enemy} do
      conn = get(conn, Routes.enemy_path(conn, :edit, enemy))
      assert html_response(conn, 200) =~ "Edit Enemy"
    end
  end

  describe "update enemy" do
    setup [:create_enemy]

    test "redirects when data is valid", %{conn: conn, enemy: enemy} do
      conn = put(conn, Routes.enemy_path(conn, :update, enemy), enemy: @update_attrs)
      assert redirected_to(conn) == Routes.enemy_path(conn, :show, enemy)

      conn = get(conn, Routes.enemy_path(conn, :show, enemy))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, enemy: enemy} do
      conn = put(conn, Routes.enemy_path(conn, :update, enemy), enemy: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Enemy"
    end
  end

  describe "delete enemy" do
    setup [:create_enemy]

    test "deletes chosen enemy", %{conn: conn, enemy: enemy, campaign: campaign} do
      conn = delete(conn, Routes.enemy_path(conn, :delete, enemy))
      assert redirected_to(conn) == Routes.enemy_path(conn, :index, campaign.id)

      assert_error_sent 404, fn ->
        get(conn, Routes.enemy_path(conn, :show, enemy))
      end
    end
  end

  defp create_enemy(%{campaign: campaign}) do
    enemy = enemy_fixture(campaign)
    %{enemy: enemy}
  end
end
