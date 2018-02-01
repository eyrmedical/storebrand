defmodule Storebrand do
  @moduledoc """
  Wrapper to use Storebrand REST API.
  """

  use HTTPoison.Base

  unless Application.get_env(:storebrand, Storebrand) do
    raise Storebrand.ConfigError, message: "Storebrand is not configured"
  end

  unless Keyword.get(Application.get_env(:storebrand, Storebrand), :url) do
    raise Storebrand.ConfigError, message: "Storebrand requires url"
  end

  @type policy :: String.t | integer()
  @type date :: String.t | %Date{}


  @doc """
  Append REST API main url.
  """
  @spec process_url(String.t) :: String.t
  def process_url(url) do
    config(:url) <> url
  end


  @doc """
  Get policy information by it's number.

  The following options are supported:

  * `:firstname`: check user first name
  * `:lastname`: check user last name
  * `:birthdate`: check user birth date in 09.11.1991 format
  """
  @spec policy_status(policy, Keyword.t) :: {:ok, map()} | {:error, Exception.t} | no_return
  def policy_status(number, opts \\ []) do
    policy_number = parse_policy_number(number)
    params = parse_options(opts)

    with {:ok, %{body: json_body, status_code: 200}} <-
        Storebrand.get("/policystatus/#{policy_number}?#{params}", headers()),
      {:ok, response} <- Poison.decode(json_body)
    do
      {:ok, response}
    else
      {:ok, %{status_code: 400}} ->
        {:error, Storebrand.InvalidRequestData}
      {:ok, %{status_code: 401}} ->
        {:error, Storebrand.NoSecurityHeader}
      {:ok, %{status_code: 404}} ->
        {:error, Storebrand.PolicyNotFound}
      {:ok, %{status_code: 406}} ->
        {:error, Storebrand.UnsupportedAcceptType}
      {:ok, %{status_code: 409}} ->
        {:error, Storebrand.NoApplication}
      {:ok, %{status_code: 500}} ->
        {:error, Storebrand.ApiError}
      {:error, _} ->
        {:error, Storebrand.ApiError}
      _ ->
        {:error, Storebrand.GenericError}
    end
  end

  
  @doc """
  Helper function to read global config in scope of this module.
  """
  def config, do: Application.get_env(:storebrand, Storebrand)
  def config(key, default \\ nil) do
    config() |> Keyword.get(key, default) |> resolve_config(default)
  end

  defp resolve_config({:system, var_name}, default),
    do: System.get_env(var_name) || default
  defp resolve_config(value, _default),
    do: value


  @spec parse_options(Keyword.t) :: String.t
  defp parse_options(opts) do
    params = Enum.reduce opts, %{}, fn(option, acc) ->
      case option do
        {:firstname, value} ->
          Map.put(acc, "firstname", value)
        {:lastname, value} ->
          Map.put(acc, "lastname", value)
        {:birthdate, value} ->
          Map.put(acc, "dateOfBirth", parse_birthdate(value))
        _ ->
          acc
      end
    end 
    URI.encode_query(params)
  end

  @spec parse_policy_number(policy) :: String.t
  defp parse_policy_number(number) when is_integer(number), do: to_string(number)
  defp parse_policy_number(number) when is_bitstring(number), do: number

  @spec parse_birthdate(date) :: String.t
  defp parse_birthdate(%Date{} = date) do
    "#{to_string(date.day)}.#{to_string(date.month)}.#{to_string(date.year)}"
  end
  defp parse_birthdate(<< _day::bytes-size(2) >> <> "." <> << _month::bytes-size(2) >>
  <> "." <> << _year::bytes-size(4) >> = param) do
    param
  end
  defp parse_birthdate(_param) do
    raise Storebrand.InvalidRequestData,
      message: "Use %Date{} struct or DD.MM.YYYY as birthdate format"
  end


  # Default headers added to all requests
  defp headers do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
  end
end
