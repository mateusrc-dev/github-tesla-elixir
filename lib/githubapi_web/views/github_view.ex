defmodule GithubapiWeb.GithubView do
  use GithubapiWeb, :view

  def render("repos.json", %{repos: repos}) do
    %{
      message: "Repos found!",
      repos: repos
    }
  end
end
