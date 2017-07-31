defmodule SimpleDocker.Image do
  defstruct repository: nil,
    id: nil,
    tag: nil,
    created_at: nil,
    size: nil

  @format """
  "{{.Repository}}, {{.ID}}, {{.Tag}}, {{.CreatedAt}}, {{.Size}}"
  """

  def build(dockerfile) do
    case docker ["image", "build", dockerfile] do
      {image_id, 0} -> {:ok, image_id}
      {error, 1} -> {:error, error}
    end
  end

  def pull(url) do
    case docker ["image", "pull", url] do
      {image_id, 0} -> {:ok, image_id}
      {error, 1} -> {:error, error}
    end
  end

  def tag(%SimpleDocker.Image{id: id}, tag_name) do
    case docker ["tag", id, tag_name] do
      {_image, 0} -> {:ok, :done}
      {error, 1} -> {:error, error}
    end
  end

  def get(repository: repo) do
    with {:ok, images} <- list_images(:all),
      nil <- Enum.find(images, & &1.repository == repo)
    do
      {:error, "Cannot find image with repository: #{repo}"}
    else
      {:error, error} -> {:error, error}
      image -> {:ok, image}
    end
  end
  def get(image_id) do
    with {:ok, images} <- list_images(:all),
      nil <- Enum.find(images, & &1.id == image_id)
    do
      {:error, "Cannot find image with id: #{image_id}"}
    else
      {:error, error} -> {:error, error}
      image -> {:ok, image}
    end
  end

  def list_images(:all) do
    case docker ["images", "--all", "--format", @format] do
      {stringified_list, 0} -> {:ok, parse_stringified_list(stringified_list)}
      {error, 1} -> {:error, error}
    end
  end

  def list_images(:active) do
    case docker ["images", "--format", @format] do
      {stringified_list, 0} -> {:ok, parse_stringified_list(stringified_list)}
      {error, 1} -> {:error, error}
    end
  end

  def remove(%SimpleDocker.Image{id: image_id}) do
    case docker ["image", "rm", "--force", image_id] do
      {message, 0} -> {:ok, message}
      {error, 1} -> {:error, error}
    end
  end
  def remove(image_id) do
    case docker ["image", "rm", "--force", image_id] do
      {message, 0} -> {:ok, message}
      {error, 1} -> {:error, error}
    end
  end

  defp docker(args) do
    try do
      case SimpleDocker.SystemInfo.get_system_type() do
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
    keys = [:repository, :id, :tag, :created_at, :size]

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

    struct(SimpleDocker.Image, params)
  end
end
