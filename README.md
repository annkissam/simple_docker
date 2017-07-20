# SimpleDocker

A lightweight/configurable interface that allows us to run docker commands through elixir.
This framework can be easily integrated in a dockerized elixir workflow as it
does not depend on any release package and does not want you to follow any
specific instructions for elixir deploys.

NOTE: This framework has support for both Mac and Linux

## Installation

This package has available in hex and can be installed as:

  1. Add `simple_docker` to your list of dependencies in `mix.exs`:


```elixir
def deps do
  [{:simple_docker, "~> 0.1.0"}]
end
```


  2. Ensure `simple_docker` is started before your application:


```elixir
def application do
  [applications: [:simple_docker]]
end
```

