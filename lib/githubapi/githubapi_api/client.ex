defmodule Githubapi.GithubapiApi.Client do
  use Tesla

  alias Tesla.Env

  @base_url "https://api.github.com/users/"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"user-agent", "Tesla"}]

  def get_user_repos(url \\ @base_url, user) do
    "#{url}#{user}/repos"
    |> get()
    |> IO.inspect()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{body: %{"message" => message}, status: 404}}) do
    {:error, %{status: :bad_request, result: message}}
  end

  defp handle_get({:ok, %Env{body: body, status: 200}}) do
    repos = Enum.map(body, fn item -> handle_body(item) end)
    {:ok, repos}
  end

  defp handle_body(%{
         "id" => id,
         "stargazers_url" => stargazers_url,
         "full_name" => full_name,
         "url" => url
       }) do
    %{
      repository: %{
        id: id,
        stargazers_url: stargazers_url,
        full_name: full_name,
        url: url
      }
    }
  end
end
