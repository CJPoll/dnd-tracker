defmodule DndTracker.Entity.Test do
  use ExUnit.Case

  @test_module DndTracker.Entity

  describe "new" do
    test "returns an entity" do
      assert %@test_module{} = @test_module.new()
    end
  end
end
