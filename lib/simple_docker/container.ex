defmodule SimpleDocker.Container do
  alias SimpleDocker.{Image, SystemInfo}

  defstruct id: nil,
    image_name: nil,
    command: nil,
    created_at: nil,
    status: nil,
    size: nil

  @format """
  "{{.ID}}, {{.Image}}, {{.Command}}, {{.CreatedAt}}, {{.Status}}, {{.Size}}"
  """

  def create(%Image{id: image_id}) do
    case docker ["container", "create", image_id] do
      {cid, 0} -> {:ok, cid}
      {error, 1} -> {:error, error}
    end
  end
  def create(image_id) when is_binary(image_id) do
    case docker ["container", "create", image_id] do
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

  def list_containers(:all) do
    case docker ["ps", "--all", "--format", @format] do
      {stringified_list, 0} -> {:ok, parse_stringified_list(stringified_list)}
      {error, 1} -> {:error, error}
    end
  end

  def list_containers(:active) do
    case docker ["ps", "--format", @format] do
      {stringified_list, 0} -> {:ok, parse_stringified_list(stringified_list)}
      {error, 1} -> {:error, error}
    end
  end

  def list_containers(%Image{repository: name}) do
    with {:ok, containers} <- list_containers(:all),
      containers <- Enum.filter(containers, & &1.image_name == name)
    do
      {:ok, containers}
    else
      {:error, error} -> {:error, error}
    end
  end

  def remove(container_id) do
    case docker ["container", "rm", "--force", container_id] do
      {message, 0} -> {:ok, message}
      {error, 1} -> {:error, error}
    end
  end

  def copy(%SimpleDocker.Container{id: container_id}, source, dest) do
    case SimpleDocker.cp(container_id, source, dest) do
      {message, 0} -> {:ok, message}
      {error, 1} -> {:error, error}
    end
  end

  defp docker(args) do
    try do
      case SystemInfo.get_system_type() do
        :mac -> System.cmd("docker", args)
        _ -> System.cmd("sudo", ["docker"] ++ args)
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

    struct(SimpleDocker.Container, params)
  end
end
