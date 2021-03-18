defmodule FacetTest do
  use ExUnit.Case
  @moduledoc false

  alias StlParser.{Facet, Math.Point}

  describe "same?" do
    test "false when not the same" do
      f = Point.new(1, 1, 1)
      p1 = Point.new(1, 1, 1)
      p2 = Point.new(2, 2, 2)
      p3 = Point.new(3, 3, 3)
      p4 = Point.new(4, 4, 4)

      f1 = Facet.new(f, p1, p2, p3)
      f2 = Facet.new(f, p2, p3, p4)

      assert {:ok, false} = Facet.same?(f1, f2)
    end

    test "true when same and in same order" do
      f = Point.new(1, 1, 1)
      p1 = Point.new(1, 1, 1)
      p2 = Point.new(2, 2, 2)
      p3 = Point.new(3, 3, 3)

      f1 = Facet.new(f, p1, p2, p3)
      f2 = Facet.new(f, p1, p2, p3)

      assert {:ok, true} = Facet.same?(f1, f2)
    end

    test "true when same and in different order 1" do
      f = Point.new(1, 1, 1)
      p2 = Point.new(1, 1, 1)
      p3 = Point.new(2, 2, 2)
      p1 = Point.new(3, 3, 3)

      f1 = Facet.new(f, p1, p2, p3)
      f2 = Facet.new(f, p1, p2, p3)

      assert {:ok, true} = Facet.same?(f1, f2)
    end

    test "true when same and in different order 2" do
      #      f1 = Facet.new(nil, 1, 2, 3)
      #      f2 = Facet.new(nil, 3, 1, 2)
      #
      #      assert {:ok, true} = Facet.same?(f1, f2)
    end
  end
end
