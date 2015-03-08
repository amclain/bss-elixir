
defmodule BssElixirTest do
  use ExUnit.Case

  test "integration" do
    {:ok, pid} = BssElixir.start_link
    assert pid
    
    :sys.trace pid, true
    
    BssElixir.connect pid, {10,10,11,5}
    BssElixir.subscribesvpercent pid, 0x100103000137, 0x0000
    
    # Ramp the gain
    BssElixir.setsvpercent pid, 0x100103000137, 0x0000, 0
    :timer.sleep 1000
    
    BssElixir.setsvpercent pid, 0x100103000137, 0x0000, 25
    :timer.sleep 1000
    
    BssElixir.setsvpercent pid, 0x100103000137, 0x0000, 50
    :timer.sleep 1000
    
    BssElixir.setsvpercent pid, 0x100103000137, 0x0000, 75
    :timer.sleep 1000
    
    BssElixir.setsvpercent pid, 0x100103000137, 0x0000, 100
    :timer.sleep 100 # Let async message propagate
  end
  
  # test "receive state changes" do
  #   {:ok, pid} = BssElixir.start_link
  #   assert pid
    
  #   :sys.trace pid, true
    
  #   BssElixir.connect pid, {10,10,11,5}
  #   BssElixir.subscribesvpercent pid, 0x100103000137, 0x0000
    
  #   IO.puts "--------------------------------------------------"
  #   IO.puts "Move fader now"
  #   IO.puts "--------------------------------------------------"
    
  #   :timer.sleep 10000
  # end
  
end
