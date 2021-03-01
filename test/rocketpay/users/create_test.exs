defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, return a user" do
      params = %{
        name: "Bruno",
        password: "123456",
        nickname: "Brf147",
        email: "brf147@test.com",
        age: 20
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Bruno", age: 20, id: ^user_id} = user
    end

    test "when there are invalid params, returns a error" do
      params = %{
        name: "Bruno",
        nickname: "Brf147",
        email: "brf147@test.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected
    end
  end

end
