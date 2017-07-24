defmodule SimpleDockerTest do
  use ExUnit.Case
  doctest SimpleDocker

  defp cleanup(container_id: container_id) do
    System.cmd("sudo", ["docker", "rm", "#{container_id}"])
  end
  defp cleanup(image_id: image_id) do
    System.cmd("sudo", ["docker", "rmi", "#{image_id}"])
  end

  setup do
    try do
      System.cmd("sudo",["docker", "--help"])
      {image_id, _} = System.cmd("sudo", ["docker", "pull", "alpine"])
      {container_id, _} = System.cmd("sudo", ["docker", "create", "alpine"])
      {
        :ok,
        %{
          container_id: String.strip(container_id),
          image_id: String.strip(image_id)
        }
      }
    rescue
      ErlangError ->
        IO.puts """
          Docker is not installed on your machine
        """
        exit(1)
    end
  end

  test "ps",%{container_id: container_id} do
    IO.inspect SimpleDocker.ps(false)
    IO.inspect SimpleDocker.ps(true)

    cleanup(container_id: container_id)
  end

  # Cleanup
end
