defmodule LemonWeb.Games.Components.BoardComponent do
  @moduledoc false

  use Phoenix.Component

  attr :game_type, :string, required: true
  attr :game_state, :map, required: true

  def board(%{game_type: "connect4"} = assigns) do
    rows = Map.get(assigns.game_state, "board", [])
    assigns = assign(assigns, :rows, rows)

    ~H"""
    <div id="connect4-board" class="inline-block rounded-xl border-4 border-blue-600 bg-blue-500 p-2 shadow-lg">
      <%= for {row, row_idx} <- Enum.with_index(@rows) do %>
        <div class="flex gap-1">
          <%= for {cell, col_idx} <- Enum.with_index(row) do %>
            <span class={connect4_cell_class(cell)} style={"animation-delay: #{row_idx * 50 + col_idx * 30}ms"} />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  def board(%{game_type: "rock_paper_scissors"} = assigns) do
    throws = Map.get(assigns.game_state, "throws", %{})
    resolved = Map.get(assigns.game_state, "resolved", false)
    winner = Map.get(assigns.game_state, "winner")

    assigns =
      assigns
      |> assign(:throws, throws)
      |> assign(:resolved, resolved)
      |> assign(:winner, winner)

    ~H"""
    <div id="rps-board" class="flex items-center gap-6 rounded-xl bg-slate-50 p-6">
      <.rps_throw player="p1" throw={Map.get(@throws, "p1")} />
      <div class="text-2xl font-black text-slate-300">VS</div>
      <.rps_throw player="p2" throw={Map.get(@throws, "p2")} />
    </div>
    """
  end

  def board(%{game_type: "tic_tac_toe"} = assigns) do
    rows = Map.get(assigns.game_state, "board", [])
    assigns = assign(assigns, :rows, rows)

    ~H"""
    <div id="tic-tac-toe-board" class="inline-block rounded-xl bg-slate-800 p-2 shadow-lg">
      <%= for row <- @rows do %>
        <div class="flex gap-1">
          <%= for cell <- row do %>
            <span class={tictactoe_cell_class(cell)}>
              {tictactoe_cell_content(cell)}
            </span>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  def board(assigns) do
    ~H"""
    <p class="text-sm text-slate-600">Unsupported game type: {@game_type}</p>
    """
  end

  def rps_throw(assigns) do
    icon = case @throw do
      "rock" -> "✊"
      "paper" -> "✋"
      "scissors" -> "✌️"
      _ -> "❓"
    end

    color = case @throw do
      nil -> "bg-slate-200 text-slate-400"
      _ -> "bg-white text-slate-900 shadow-md"
    end

    assigns = assign(assigns, icon: icon, color: color)

    ~H"""
    <div class={["flex h-20 w-20 items-center justify-center rounded-full text-4xl transition-all", @color]}>
      {@icon}
    </div>
    """
  end

  defp connect4_cell_class(0), do: "block h-10 w-10 rounded-full bg-slate-200 shadow-inner"
  defp connect4_cell_class(1), do: "block h-10 w-10 rounded-full bg-red-500 shadow-md"
  defp connect4_cell_class(2), do: "block h-10 w-10 rounded-full bg-yellow-400 shadow-md"
  defp connect4_cell_class(_), do: "block h-10 w-10 rounded-full bg-slate-400"

  defp tictactoe_cell_class(nil), do: "flex h-16 w-16 items-center justify-center rounded-lg bg-slate-700 text-2xl font-bold text-slate-600 transition-all hover:bg-slate-600"
  defp tictactoe_cell_class("X"), do: "flex h-16 w-16 items-center justify-center rounded-lg bg-slate-700 text-2xl font-bold text-blue-400 shadow-lg"
  defp tictactoe_cell_class("O"), do: "flex h-16 w-16 items-center justify-center rounded-lg bg-slate-700 text-2xl font-bold text-rose-400 shadow-lg"
  defp tictactoe_cell_class(_), do: "flex h-16 w-16 items-center justify-center rounded-lg bg-slate-700 text-2xl font-bold"

  defp tictactoe_cell_content(nil), do: ""
  defp tictactoe_cell_content(cell), do: cell
end
