
defmodule BssElixirTest do
  use ExUnit.Case

  test "init" do
    {:ok, pid} = BssElixir.start_link
    IO.inspect pid
    assert pid
    
    BssElixir.connect pid, {10,10,3,1}
  end
  
end
