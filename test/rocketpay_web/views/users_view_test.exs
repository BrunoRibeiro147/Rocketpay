defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias RocketpayWeb.UsersView
  alias Rocketpay.{Account, User}

  test "renders create.json" do
    params = %{
      name: "Bruno",
      password: "123456",
      nickname: "Brf147",
      email: "brf147@test.com",
      age: 20
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} = Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id,
        },
        id: user_id,
        name: "Bruno",
        nickname: "Brf147"
        }
      }

    assert expected == response
  end

end
