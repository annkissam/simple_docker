defmodule SimpleDocker.Container do
  alias SimpleDocker.{Container, Image, SystemInfo}

  defstruct id: nil,
    image_name: nil,
    command: nil,
    created_at: nil,
    status: nil,
    size: nil

  @format """
  "{{.ID}}, {{.Image}}, {{.Command}}, {{.CreatedAt}}, {{.Status}}, {{.Size}}"
  """

  def create(image_or_id, stdio \\ false)
  def create(%Image{id: image_id}, stdio) do
    case docker ["container", "create", image_id], stdio do
      {cid, 0} -> {:ok, String.slice(cid, 0..11)}
      {error, 1} -> {:error, error}
    end
  end
  def create(image_id, stdio) when is_binary(image_id) do
    case docker ["container", "create", image_id], stdio do
      {cid, 0} -> {:ok, cid}
      {error, 1} -> {:error, error}
    end
  end

  def get(container_id) do
    with {:ok, containers} <- list_containers(:all),
      nil <- Enum.find(containers, & &1.id == container_id)
    do
      {:error, "Cannot find container with id: #{container_id}"}
    else
      {:error, error} -> {:error, error}
      container -> {:ok, container}
    end
  end

  def list_containers(active_or_all_or_image, stdio \\ false)
  def list_containers(:all, stdio) do
    case docker ["ps", "--all", "--format", @format], stdio do
      {stringified_list, 0} -> {:ok, parse_stringified_list(stringified_list)}
      {error, 1} -> {:error, error}
    end
  end
  def list_containers(:active, stdio) do
    case docker ["ps", "--format", @format], stdio do
      {stringified_list, 0} -> {:ok, parse_stringified_list(stringified_list)}
      {error, 1} -> {:error, error}
    end
  end

  def list_containers(%Image{repository: name}, _stdio) do
    with {:ok, containers} <- list_containers(:all),
      containers <- Enum.filter(containers, & &1.image_name == name)
    do
      {:ok, containers}
    else
      {:error, error} -> {:error, error}
    end
  end

  def remove(container_id, stdio \\ false) do
    case docker ["container", "rm", "--force", container_id], stdio do
      {message, 0} -> {:ok, message}
      {error, 1} -> {:error, error}
    end
  end

  def copy(%Container{id: container_id}, source, dest, stdio \\ false) do
    case SimpleDocker.cp(container_id, source, dest, stdio) do
      {message, 0} -> {:ok, message}
      {error, 1} -> {:error, error}
    end
  end

  defp docker(args, stdio) do
    opts = stdio && [into: IO.stream(:stdio, :line)] || []

    try do
      case SystemInfo.get_system_type() do
        :mac -> System.cmd("docker", args, opts)
        _ -> System.cmd("sudo", ["docker"] ++ args, opts)
      end
    rescue
      e in ErlangError -> {e, 1}
    end
  end

  defp parse_stringified_list(stringified_list) do
    stringified_list
    |> String.trim("\n\n")
    |> String.split("\n\n")
    |> Enum.map(&parse_to_struct(&1))
  end

  defp parse_to_struct(formatted_container) do
    keys = [:id, :image_name, :command, :created_at, :status, :size]

    params = formatted_container
      |> String.trim("\"")
      |> String.split(", ")
      |> Enum.reduce({[], keys}, fn(value, {keyword, rem_keys}) ->
        value = String.trim(value, "\"")
        key = Enum.at(rem_keys, 0)
        rem_keys = List.delete_at(rem_keys, 0)
        {Keyword.put_new(keyword, key, value), rem_keys}
      end)
      |> (&elem(&1, 0)).()
      |> Enum.into(%{})

    struct(Container, params)
  end
end
