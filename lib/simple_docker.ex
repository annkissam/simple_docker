defmodule SimpleDocker do
  require SimpleDocker.SystemInfo

  def build(dockerfile, tag) do
    docker ["build", "-f", dockerfile, "-t", tag]
  end

  def cp(cid, source, dest) do
    docker ["cp", "#{cid}:#{source}", dest]
  end

  def ps() do
    docker ["ps"]
  end

  def images() do
    docker ["images"]
  end

  def rmi(image_id) do
    docker ["rmi", image_id]
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
    case SimpleDocker.SystemInfo.get_system_type() do
      :mac -> System.cmd("docker", args)
      _ -> System.cmd("sudo", ["docker"] ++ args)
    end
  end
end
