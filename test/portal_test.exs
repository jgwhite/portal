defmodule PortalTest do
  use ExUnit.Case

  test "pushing left and right" do
    Portal.shoot(:a)
    Portal.shoot(:b)

    portal = Portal.transfer(:a, :b, [1, 2, 3, 4])

    assert Portal.Door.get(:a) == [4, 3, 2, 1]
    assert Portal.Door.get(:b) == []

    Portal.push_right(portal)

    assert Portal.Door.get(:a) == [3, 2, 1]
    assert Portal.Door.get(:b) == [4]

    Portal.push_right(portal)

    assert Portal.Door.get(:a) == [2, 1]
    assert Portal.Door.get(:b) == [3, 4]

    Portal.push_left(portal)

    assert Portal.Door.get(:a) == [3, 2, 1]
    assert Portal.Door.get(:b) == [4]
  end
end
