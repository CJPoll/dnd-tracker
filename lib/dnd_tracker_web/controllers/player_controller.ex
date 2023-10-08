defmodule DndTrackerWeb.PlayerController do
  use DndTrackerWeb, :controller

  alias DndTracker.Campaigns
  alias DndTracker.Campaigns.Player

  plug :scrub_params, "campaign_id" when action in [:create, :new, :index]

  def index(conn, %{"campaign_id" => campaign_id}) do
    campaign = Campaigns.get_campaign(campaign_id)
    players = Campaigns.list_players(campaign)
    render(conn, "index.html", players: players, campaign: campaign)
  end

  def index(conn, _params) do
    conn
    |> send_resp(400, "campaign not sent")
  end

  def new(conn, %{"campaign_id" => campaign_id}) do
    campaign = Campaigns.get_campaign(campaign_id)
    changeset = Campaigns.change_player(%Player{})
    render(conn, "new.html", changeset: changeset, campaign: campaign)
  end

  def create(conn, %{"player" => player_params, "campaign_id" => campaign_id}) do
    campaign = Campaigns.get_campaign(campaign_id)

    case Campaigns.create_player(campaign, player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: Routes.player_path(conn, :show, player))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Campaigns.get_player!(id)
    render(conn, "show.html", player: player)
  end

  def edit(conn, %{"id" => id}) do
    player = Campaigns.get_player!(id)
    changeset = Campaigns.change_player(player)
    render(conn, "edit.html", player: player, changeset: changeset)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Campaigns.get_player!(id)

    case Campaigns.update_player(player, player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: Routes.player_path(conn, :show, player))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", player: player, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Campaigns.get_player!(id)
    {:ok, _player} = Campaigns.delete_player(player)

    conn
    |> put_flash(:info, "Player deleted successfully.")
    |> redirect(to: Routes.player_path(conn, :index, player.campaign))
  end
end
