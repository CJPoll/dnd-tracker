# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DndTracker.Repo.insert!(%DndTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DndTracker.Campaigns.{Campaign, Player}
alias DndTracker.Repo

campaign = %Campaign{name: "Campaign 1"} |> Repo.insert!()

%Player{name: "Brandon", campaign_id: campaign.id} |> Repo.insert!()
%Player{name: "Carter", campaign_id: campaign.id} |> Repo.insert!()
%Player{name: "Mike", campaign_id: campaign.id} |> Repo.insert!()
%Player{name: "Scott", campaign_id: campaign.id} |> Repo.insert!()
