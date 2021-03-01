defmodule RocketpayWeb.WelcomeControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "index/2" do

    test "when name exist, return welcome message with number", %{conn: conn} do
      query = "numbers"

      response =
        conn
        |> get(Routes.welcome_path(conn, :index, query))
        |> json_response(:ok)

      assert %{"message" => "Welcome to Rocketpay API. Here is your number 37"} = response

    end

    test "when name does not exist, return a bad request", %{conn: conn} do
      query = "banana"

      response =
        conn
        |> get(Routes.welcome_path(conn, :index, query))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid File"} = response
    end

  end

end
