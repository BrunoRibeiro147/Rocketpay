defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "create/2" do
  test "when all params are valid, create a user", %{conn: conn} do
    params = %{
      name: "Bruno",
      password: "123456",
      nickname: "Brf147",
      email: "brf147@test.com",
      age: 20
    }

    response =
      conn
      |> post(Routes.users_path(conn, :create, params))
      |> json_response(:created)

    assert %{
              "message" => "User created",
              "user" => %{
              "account" => %{
                  "balance" => "0.00",
                  "id" => _account,
              },
              "id" => _user,
              "name" => "Bruno",
              "nickname" => "Brf147"
          }
      } = response
  end




  end

end
