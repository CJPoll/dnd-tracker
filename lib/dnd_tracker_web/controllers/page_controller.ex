defmodule DndTrackerWeb.PageController do
  use DndTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
