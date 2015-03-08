
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
    IO.puts "Value: #{data}\n"
    data = data * 65536
    packet = SoundwebMessage.struct_to_binary \
      %{cmd: 0x8D, addr: addr, sv: sv, data: data}
    
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
