defmodule StorebrandTest do
  use ExUnit.Case
  doctest Storebrand

  test "policy number check with random data not found" do
    {:error, error} = Storebrand.policy_status("6876869797987")
    assert error === Storebrand.PolicyNotFound
  end

  test "valid policy number without additional params not found" do
    {:error, error} = Storebrand.policy_status("1134152")
    assert error === Storebrand.PolicyNotFound
  end

  test "valid policy number check" do
    {:ok, response} = Storebrand.policy_status("1134152", [
      firstname: "Inger Renate",
      lastname: "Fagernes",
      birthdate: "09.11.1991"
    ])
    assert response["valid"] === true
  end
end
