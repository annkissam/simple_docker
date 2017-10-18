defmodule Mix.Tasks.SimpleDocker.Build do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to build from a dockerfile with a tag.

  Usage:
  `$ mix simple_docker.build --f <path-to-dockerfile> --t <image-tag> `
  """

  @switches [f: :string, t: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[f: dockerfile, t: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.build(dockerfile, tag, true)
  end
end

defmodule Mix.Tasks.SimpleDocker.Cp do
  use Mix.Task

  @moduledoc """
  Mix task that can be to copy files from a container to destination.

  Usage:
  `$ mix simple_docker.cp --continer <contianer-id-or-tag> --from <source> --to <destination> `
  """

  @switches [container: :string, from: :string, to: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[container: cid, from: source, to: dest], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.cp(cid, source, dest, true)
  end
end

defmodule Mix.Tasks.SimpleDocker.Ps do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to list all the containers.

  Usage:
  - `$ mix simple_docker.ps --all` : Lists all containers
  - `$ mix simple_docker.ps` : Lists active containers
  """

  @switches [all: :boolean]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {opts, _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.ps(opts[:all], true)
  end
end

defmodule Mix.Tasks.SimpleDocker.Images do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to list all the images.

  Usage:
  `$ mix simple_docker.images`
  """

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(_), do: SimpleDocker.images(true)
end

defmodule Mix.Tasks.SimpleDocker.Create do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to create a container from an image.

  Usage:
  `$ mix simple_docker.create --image <image-name> --name <container-name>`
  or
  `$ mix simple_docker.create --image <image-name>` : Container will have no name
  """

  @switches [image: :string, name: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[image: image] = opts, _, _} =
      OptionParser.parse(argv, switches: @switches)

    case opts[:name] do
      nil -> SimpleDocker.create(image, nil, true)
      name -> SimpleDocker.create(image, name, true)
    end
  end
end

defmodule Mix.Tasks.SimpleDocker.Rm do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to remove a container.

  Usage:
  `$ mix simple_docker.remove --container <container-id-or-name>`
  """

  @switches [container: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[container: cid], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.rm(cid, true)
  end
end

defmodule Mix.Tasks.SimpleDocker.Rmi do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to remove an image.

  Usage:
  `$ mix simple_docker.rmi --image <image-id-or-tag>`
  """

  @switches [image: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[image: image_id], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.rmi(image_id, true)
  end
end

defmodule Mix.Tasks.SimpleDocker.Tag do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to tag an image.

  Usage:
  `$ mix simple_docker.tag --image <image-id-or-tag> --tag <tag-name>`
  """

  @switches [image: :string, tag: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[image: image, tag: tag], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.tag(image, tag, true)
  end
end

defmodule Mix.Tasks.SimpleDocker.Push do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to push an image to remote.

  Usage:
  `$ mix simple_docker.push --image <image-name-or-tag> --tag <tag-to-push-by>`
  """

  @switches [image: :string]

  @doc """
  Delegates the arguments to SimpleDocker and prints the output
  """
  def run(argv) do
    {[image: image], _, _} =
      OptionParser.parse(argv, switches: @switches)

    SimpleDocker.push(image, true)
  end
end
