defmodule Mix.Tasks.SimpleDocker.Build do
  use Mix.Task

  @switches [f: :string, t: :string]

  def run(argv) do
    {[f: dockerfile, t: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.build(dockerfile, tag)
  end
end

defmodule Mix.Tasks.SimpleDocker.Cp do
  use Mix.Task

  @switches [container: :string, from: :string, to: :string]

  def run(argv) do
    {[container: cid, from: source, to: dest], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.cp(cid, source, dest)
  end
end

defmodule Mix.Tasks.SimpleDocker.Ps do
  use Mix.Task

  def run(_), do: SimpleDocker.ps()
end

defmodule Mix.Tasks.SimpleDocker.Create do
  use Mix.Task

  @switches [container: :string, from: :string, to: :string]

  def run(argv) do
    {[container: cid, from: source, to: dest], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.cp(cid, source, dest)
  end
end

defmodule Mix.Tasks.SimpleDocker.Rm do
  use Mix.Task

  @switches [container: :string]

  def run(argv) do
    {[container: cid], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.rm(cid)
  end
end

defmodule Mix.Tasks.SimpleDocker.Tag do
  use Mix.Task

  @switches [image: :string, tag: :string]

  def run(argv) do
    {[image: image, tag: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.tag(image, tag)
  end
end

defmodule Mix.Tasks.SimpleDocker.Push do
  use Mix.Task

  @switches [image: :string, tag: :string]

  def run(argv) do
    {[image: image, tag: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.push(image, tag)
  end
end
