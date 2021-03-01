defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Bruno",
        password: "123456",
        nickname: "Brf147",
        email: "brf147@test.com",
        age: 20
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
      conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, params))
      |> json_response(:ok)

      assert %{
                "account" => %{"balance" => "50.00", "id" => _id},
                "message" => "Balance changed successfully"
              } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
      conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, params))
      |> json_response(:bad_request)

      expected = %{"message" => "Invalid deposit value"}

      assert response == expected
    end

  end

  describe "withdraw" do
    setup %{conn: conn} do
      params = %{
        name: "Bruno",
        password: "123456",
        nickname: "Brf147",
        email: "brf147@test.com",
        age: 20
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, %{"value" => "50.00"}))

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the withdraw", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
      conn
      |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
      |> json_response(:ok)

      assert %{
                "account" => %{"balance" => "0.00", "id" => _id},
                "message" => "Balance changed successfully"
              } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
      conn
      |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
      |> json_response(:bad_request)

      expected = %{"message" => "Invalid deposit value"}

      assert response == expected
    end
  end

  describe "transaction/2" do
    setup %{conn: conn} do
      params = %{
        name: "Bruno",
        password: "123456",
        nickname: "Brf147",
        email: "brf147@test.com",
        age: 20
      }

      {:ok, %User{account: %Account{id: from}}} = Rocketpay.create_user(params)

      params2 = %{
        name: "Fabiano",
        password: "123456",
        nickname: "fabiano",
        email: "bruno147@test.com",
        age: 20
      }

      {:ok, %User{account: %Account{id: to}}} = Rocketpay.create_user(params2)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      conn
      |> post(Routes.accounts_path(conn, :deposit, from, %{"value" => "50.00"}))

      {:ok, conn: conn, from_id: from, to_id: to}
    end

    test "when all params are valid, make the transaction", %{conn: conn, from_id: from, to_id: to} do
      params = %{"from" => from, "to" => to, "value" => "30.00"}

      response =
      conn
      |> post(Routes.accounts_path(conn, :transaction, params))
      |> json_response(:ok)

      assert %{
                "message" => "Transaction made successfully",
                "transaction" =>
                  %{
                    "from_account" => %{"balance" => "20.00", "id" => _from},
                    "to_account" => %{"balance" => "30.00", "id" =>  _to}
                    }
              } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, from_id: from, to_id: to} do
      params = %{"from" => from, "to" => to, "value" => "banana"}

      response =
      conn
      |> post(Routes.accounts_path(conn, :transaction, params))
      |> json_response(:bad_request)

      expected = %{"message" => "Invalid deposit value"}

      assert response == expected
    end

  end


end
