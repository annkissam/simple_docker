defmodule SimpleDocker.SystemInfo do

  # Works for only Mac OSX or Ubuntu
  def get_system_type() do
    try do
      System.cmd("system_profiler", ["SPSoftwareDataType"])
      :mac
    rescue
      ErlangError -> :ubuntu
    end
  end
end
