defmodule StlParser.Math.TriangleTest do
  use ExUnit.Case

  alias StlParser.Math.{Point, Triangle}

  @moduletag :capture_log

  test "calculate area" do
    vertices = %{
      vert1: Point.new(0, 0, 0),
      vert2: Point.new(1, 0, 0),
      vert3: Point.new(1, 1, 1)
    }

    area = Triangle.calculate_area(vertices)
    assert Float.round(area, 4) == 0.7071
  end

  test "heron's formula" do
    a = 3
    b = 5
    c = 4
    assert Triangle.heron(a, b, c) == 6.0
  end

  test "heron's formula simple example 2" do
    a = 5
    b = 12
    c = 13
    assert Triangle.heron(a, b, c) == 30.0
  end
end
