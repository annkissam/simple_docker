defmodule SimpleDocker do
  require SimpleDocker.SystemInfo

  def build(dockerfile, tag, stdio \\ false) do
    docker ["build", "-f", dockerfile, "-t", tag, "."], stdio
  end

  def cp(cid, source, dest, stdio \\ false) do
    docker ["cp", "#{cid}:#{source}", dest], stdio
  end

  def ps(all, stdio \\ false)
  def ps(true, stdio) do
    docker ["ps", "-a"], stdio
  end
  def ps(_, stdio) do
    docker ["ps"], stdio
  end

  def images(stdio \\ false) do
    docker ["images"], stdio
  end

  def rmi(image_id, stdio \\ false) do
    docker ["rmi", image_id], stdio
  end

  def create(image, name, stdio \\ false)
  def create(image, nil, stdio) do
    docker ["create", image], stdio
  end
  def create(image, name, stdio) do
    docker ["create", "--name", name, image], stdio
  end

  def tag(image, tag, stdio \\ false) do
    docker ["tag", image, tag], stdio
  end

  def push(image, args, stdio \\ false) do
    docker ["push"] ++ args ++ [image], stdio
  end

  def rm(cid, stdio \\ false) do
    docker ["rm", "-f", cid], stdio
  end

  defp docker(args, stdio) do
    opts = stdio && [into: IO.stream(:stdio, :line)] || []

    try do
      case SimpleDocker.SystemInfo.get_system_type() do
        :mac -> System.cmd("docker", args, opts)
        _ -> System.cmd("sudo", ["docker"] ++ args, opts)
      end
    rescue
      e in ErlangError -> {e, 1}
    end
  end
end
