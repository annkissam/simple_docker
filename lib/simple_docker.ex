defmodule SimpleDocker do
  require Logger

  def build(dockerfile, tag) do
    docker ["build", "-f", dockerfile, "-t", tag]
  end

  def cp(cid, source, dest) do
    docker ["cp", "#{cid}:#{source}", dest]
  end

  def ps() do
    docker ["ps", "-a", "-q"]
  end

  def create(name, image) do
    docker ["create", "--name", name, image]
  end

  def tag(image, tag) do
    docker ["tag", image, tag]
  end

  def push(image, args) do
    docker ["push"] ++ args ++ [image]
  end

  def rm(cid) do
    docker ["rm", "-f", cid]
  end

  defp docker(args) do
    Logger.debug "$ docker #{args |> Enum.join(" ")}"

    case get_system_type() do
      :mac -> System.cmd("docker", args, into: IO.stream(:stdio, :line))
      _ -> System.cmd("sudo docker", args, into: IO.stream(:stdio, :line))
    end
  end

  # Works for only Mac OSX or Ubuntu
  defp get_system_type() do
    try do
      System.cmd("system_profiler", ["SPSoftwareDataType"])
      :mac
    rescue
      ErlangError -> :ubuntu
    end
  end
end
