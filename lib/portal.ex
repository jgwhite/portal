defmodule Portal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Portal.Door, [])
    ]

    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defstruct [:left, :right]

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end

  @doc """
  Starts transferring `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    for item <- data do
      Portal.Door.push(left, item)
    end

    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`.
  """
  def push_right(portal) do
    push(portal, portal.left, portal.right)
  end

  @doc """
  Pushes data to the left in the given `portal`.
  """
  def push_left(portal) do
    push(portal, portal.right, portal.left)
  end

  defp push(portal, from, to) do
    case Portal.Door.pop(from) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(to, h)
    end

    portal
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door  = inspect(left)
    right_door = inspect(right)

    left_data  = Portal.Door.get(left) |> Enum.reverse |> inspect
    right_data = Portal.Door.get(right) |> inspect

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
