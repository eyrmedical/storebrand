# Storebrand

A simple wrapper for Storebrand REST API.

## Installation

Package can be installed by adding `storebrand` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:storebrand, "~> 0.1"}]
end
```

### Config

Copy your push service credentials from Bluemix UI, to application config file:

```
config :storebrand, Storebrand,
  url: "https://xsg.storebrand.no/helseapp/fdc"
```

# Usage

Check the `test` folder for usage examples.

## Policies

### Check policy validity
`{:ok, response} = Storebrand.policy_status("XXXXXXXX", [
  firstname: "First Name",
  lastname: "Last Name",
  birthdate: "01.01.1991"
])`

# Disclaimer

**This library was designed for an internal usage**

