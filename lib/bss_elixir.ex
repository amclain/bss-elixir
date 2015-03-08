
defmodule BssElixir do
  use GenServer
  
  def start_link do
    state = %{connection: nil}
    GenServer.start_link __MODULE__, state
  end
  
  def connect pid, ip do
    connect pid, ip, 1023
  end
  
  def connect pid, ip, port do
    GenServer.call pid, {:connect, ip, port}
  end
  
  def setsvpercent pid, addr, sv, data do
    data = data * 65536
    send_packet pid, 0x8D, addr, sv, data
  end
  
  def subscribesvpercent pid, addr, sv do
    send_packet pid, 0x8E, addr, sv, 0
  end
  
  def unsubscribesvpercent pid, addr, sv do
    send_packet pid, 0x8F, addr, sv, 0
  end
  
  defp send_packet pid, cmd, addr, sv, data do
    IO.puts "Value: #{data}\n"
    packet = SoundwebMessage.struct_to_binary \
      %{cmd: cmd, addr: addr, sv: sv, data: data}
    
    GenServer.cast pid, {:packet, packet}
  end
  
  # Callbacks
  
  def handle_call {:connect, ip, port}, _from, state do
    {:ok, socket} = :gen_tcp.connect ip, port, [:binary, active: true]
    IO.puts "Connected to BSS at: #{inspect ip}:#{port}~n"
    state = %{state | connection: socket}
    {:reply, :connecting, state}
  end
  
  def handle_cast {:packet, packet}, state do
    :gen_tcp.send state[:connection], packet
    {:noreply, state}
  end
  
end
