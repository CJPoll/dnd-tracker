defmodule DndTrackerWeb.EnemyController do
  use DndTrackerWeb, :controller

  alias DndTracker.Campaigns
  alias DndTracker.Campaigns.Campaign
  alias DndTracker.Encounters.{Enemies, Enemy}
  alias DndTracker.Encounters.Enemy

  plug :scrub_params, "campaign_id" when action in [:create, :new, :index]

  def index(conn, %{"campaign_id" => campaign_id}) do
    campaign = Campaigns.get_campaign(campaign_id)
    enemies = Enemies.list_enemies(campaign)
    render(conn, "index.html", enemies: enemies, campaign: campaign)
  end

  def new(conn, %{"campaign_id" => campaign_id}) do
    campaign = Campaigns.get_campaign(campaign_id)

    enemy = Enemies.generate(5)

    enemy =
      %Enemy{enemy | campaign_id: campaign.id}
      |> IO.inspect(label: "Enemy")

    params =
      Enemy.to_params(enemy)
      |> IO.inspect(label: "Enemy Params")

    changeset =
      campaign
      |> Campaign.add_enemy_changeset()
      |> Enemies.change_enemy(params)
      |> IO.inspect(label: "Enemy Changeset")

    render(conn, "new.html", changeset: changeset, campaign: campaign)
  end

  def create(conn, %{"enemy" => enemy_params, "campaign_id" => campaign_id}) do
    campaign = Campaigns.get_campaign(campaign_id)

    case Enemies.create_enemy(campaign, enemy_params) do
      {:ok, enemy} ->
        conn
        |> put_flash(:info, "Enemy created successfully.")
        |> redirect(to: Routes.enemy_path(conn, :show, enemy))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "Insert failed")
        render(conn, "new.html", changeset: changeset, campaign: campaign)
    end
  end

  def show(conn, %{"id" => id}) do
    enemy = Enemies.get_enemy!(id)
    render(conn, "show.html", enemy: enemy)
  end

  def edit(conn, %{"id" => id}) do
    enemy = Enemies.get_enemy!(id)
    changeset = Enemies.change_enemy(enemy)
    render(conn, "edit.html", enemy: enemy, changeset: changeset, campaign: enemy.campaign)
  end

  def update(conn, %{"id" => id, "enemy" => enemy_params}) do
    enemy = Enemies.get_enemy!(id)

    case Enemies.update_enemy(enemy, enemy_params) do
      {:ok, enemy} ->
        conn
        |> put_flash(:info, "Enemy updated successfully.")
        |> redirect(to: Routes.enemy_path(conn, :show, enemy))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", enemy: enemy, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    enemy = Enemies.get_enemy!(id)
    {:ok, _enemy} = Enemies.delete_enemy(enemy)

    conn
    |> put_flash(:info, "Enemy deleted successfully.")
    |> redirect(to: Routes.enemy_path(conn, :index, enemy.campaign))
  end
end
