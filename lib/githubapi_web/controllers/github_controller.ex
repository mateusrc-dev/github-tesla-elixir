defmodule GithubapiWeb.GithubController do
  use GithubapiWeb, :controller
  alias GithubapiWeb.FallbackController
  alias Githubapi.GithubapiApi.Client

  action_fallback FallbackController

  def show(conn, %{"user" => user}) do
    with {:ok, repos} <- Client.get_user_repos(user) do
      conn
      |> put_status(:ok)
      |> render("repos.json", repos: repos)
    end
  end
end
