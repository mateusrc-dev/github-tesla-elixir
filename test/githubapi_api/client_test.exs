defmodule Githubapi.GithubapiApi.ClientTest do
  use ExUnit.Case, async: true
  alias Githubapi.GithubapiApi.Client
  alias Plug.Conn

  describe "get_user_repos/1" do
    setup do
      bypass = Bypass.open()

      # to make call to local server which bypass will activate

      {:ok, bypass: bypass}
    end

    test "when there is a valid user, returns the repositories info", %{bypass: bypass} do
      user = "lucas"
      url = endpoint_url(bypass.port)

      body = ~s([
          {
              "full_name": "lucas/dnsping",
              "id": 66802385,
              "stargazers_url": "https://api.github.com/repos/lucas/dnsping/stargazers",
              "url": "https://api.github.com/repos/lucas/dnsping"
          },
          {
              "full_name": "lucas/mrjob",
              "id": 111040231,
              "stargazers_url": "https://api.github.com/repos/lucas/mrjob/stargazers",
              "url": "https://api.github.com/repos/lucas/mrjob"
          },
          {
              "full_name": "lucas/MultipartPostHandler2",
              "id": 42890251,
              "stargazers_url": "https://api.github.com/repos/lucas/MultipartPostHandler2/stargazers",
              "url": "https://api.github.com/repos/lucas/MultipartPostHandler2"
          },
          {
              "full_name": "lucas/xhtml2pdf",
              "id": 39463528,
              "stargazers_url": "https://api.github.com/repos/lucas/xhtml2pdf/stargazers",
              "url": "https://api.github.com/repos/lucas/xhtml2pdf"
          }
        ])

      # requests in Bypass occur in localhost - over it, we will have that use a url different
      # this expect bypass is a mock
      Bypass.expect(bypass, "GET", "#{user}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_user_repos(url, user)

      expected_response =
        {:ok,
         [
           %{
             repository: %{
               full_name: "lucas/dnsping",
               id: 66_802_385,
               stargazers_url: "https://api.github.com/repos/lucas/dnsping/stargazers",
               url: "https://api.github.com/repos/lucas/dnsping"
             }
           },
           %{
             repository: %{
               full_name: "lucas/mrjob",
               id: 111_040_231,
               stargazers_url: "https://api.github.com/repos/lucas/mrjob/stargazers",
               url: "https://api.github.com/repos/lucas/mrjob"
             }
           },
           %{
             repository: %{
               full_name: "lucas/MultipartPostHandler2",
               id: 42_890_251,
               stargazers_url:
                 "https://api.github.com/repos/lucas/MultipartPostHandler2/stargazers",
               url: "https://api.github.com/repos/lucas/MultipartPostHandler2"
             }
           },
           %{
             repository: %{
               full_name: "lucas/xhtml2pdf",
               id: 39_463_528,
               stargazers_url: "https://api.github.com/repos/lucas/xhtml2pdf/stargazers",
               url: "https://api.github.com/repos/lucas/xhtml2pdf"
             }
           }
         ]}

      assert response == expected_response
    end

    test "when the user is not found, returns an error", %{bypass: bypass} do
      user = "njkfhcnaioehfsdioaufhncsui"

      url = endpoint_url(bypass.port)

      body = ~s({"message": "Not Found"})

      # requests in Bypass occur in localhost - over it, we will have that use a url different
      # this expect bypass is a mock
      Bypass.expect(bypass, "GET", "#{user}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(404, body)
      end)

      response = Client.get_user_repos(url, user)

      expected_response = {:error, %{result: "Not Found", status: :bad_request}}

      assert response == expected_response
    end

    defp endpoint_url(port) do
      "http://localhost:#{port}/"
    end
  end
end
