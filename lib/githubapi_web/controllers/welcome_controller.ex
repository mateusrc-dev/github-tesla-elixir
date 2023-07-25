defmodule GithubapiWeb.WelcomeController do
  use GithubapiWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> text("oiiie!")
  end
end
