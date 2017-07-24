defmodule Mix.Tasks.SimpleDocker.Build do
  use Mix.Task

  @switches [f: :string, t: :string]

  def run(argv) do
    {[f: dockerfile, t: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.build(dockerfile, tag), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Cp do
  use Mix.Task

  @switches [container: :string, from: :string, to: :string]

  def run(argv) do
    {[container: cid, from: source, to: dest], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.cp(cid, source, dest), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Ps do
  use Mix.Task
  @switches [all: :boolean]

  def run(argv) do
    {opts, _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.ps(opts[:all]), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Images do
  use Mix.Task

  def run(_), do: IO.puts elem(SimpleDocker.images(), 0)
end

defmodule Mix.Tasks.SimpleDocker.Create do
  use Mix.Task

  @switches [container: :string, from: :string, to: :string]

  def run(argv) do
    {[container: cid, from: source, to: dest], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.cp(cid, source, dest), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Rm do
  use Mix.Task

  @switches [container: :string]

  def run(argv) do
    {[container: cid], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.rm(cid), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Rmi do
  use Mix.Task

  @switches [image: :string]

  def run(argv) do
    {[image: image_id], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.rmi(image_id), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Tag do
  use Mix.Task

  @switches [image: :string, tag: :string]

  def run(argv) do
    {[image: image, tag: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.tag(image, tag), 0)
  end
end

defmodule Mix.Tasks.SimpleDocker.Push do
  use Mix.Task

  @switches [image: :string, tag: :string]

  def run(argv) do
    {[image: image, tag: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    IO.puts elem(SimpleDocker.push(image, tag), 0)
  end
end
