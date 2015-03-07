
defmodule SoundwebMessage do
  use Bitwise
  
  def unescape bin do
    :erlang.list_to_binary unescape(:erlang.binary_to_list(bin), [])
  end
  
  defp unescape [], acc do
    :lists.reverse acc
  end
  
  defp unescape [0x1B|next], acc do
    [h|t] = next
    unescape t, [h - 0x80 | acc]
  end
  
  defp unescape [h|t], acc do
    unescape t, [h | acc]
  end
  
  def escape bin do
    :erlang.list_to_binary escape(:erlang.binary_to_list(bin), [])
  end
  
  defp escape [], acc do
    :lists.reverse acc
  end
  
  defp escape [h|t], acc do
    case h do
      # TODO: Refactor
      0x02 -> escape t, [(h + 0x80) | [0x1B | acc]]
      0x03 -> escape t, [(h + 0x80) | [0x1B | acc]]
      0x06 -> escape t, [(h + 0x80) | [0x1B | acc]]
      0x15 -> escape t, [(h + 0x80) | [0x1B | acc]]
      0x1B -> escape t, [(h + 0x80) | [0x1B | acc]]
      _ -> escape t, [h|acc]
    end
  end
  
  # def binary_to_struct bin do
  #   # bin = :erlang.binary_to_list bin
    
  #   <<0x02::8, bin::binary>> = bin
  #   <<0x03::8, checksum::8, bin::binary>> = String.reverse bin
  #   bin = unescape String.reverse(bin)
    
  #   # <<cmd::8, addr::48, sv::16, data::32>> = bin
    
  #   IO.inspect bin
  #   cs = :lists.foldl fn(x,a) -> bxor(x,a) end, 0, :erlang.binary_to_list(bin)
  #   IO.inspect checksum
  #   IO.inspect cs
    
  #   # [0x03|bin] = :lists.reverse bin
  #   # bin = :lists.reverse bin
    
    
  #   # :erlang.list_to_binary bin
  # end
  
end
