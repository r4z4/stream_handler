defmodule StreamHandlerWeb.SharedComponents do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  def display_card(assigns) do
    ~H"""
    The chosen city is: <%= @name %>.
    """
  end

  def button_card(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4 w-full">
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[1] do 10 else 1 end}
          value={1}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[1] do %>Stop Slugs<% else %>Start Slugs<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[2] do 11 else 2 end}
          value={2}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[2] do %>Stop Emojis<% else %>Start Emojis<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[3] do 12 else 3 end}
          value={3}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[3] do %>Stop Activities<% else %>Start Activities<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[4] do 13 else 4 end}
          value={4}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[4] do %>Stop WS<% else %>Start WS<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[5] do 14 else 5 end}
          value={5}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[5] do %>Stop All Services<% else %>Start All Services<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[6] do 15 else 6 end}
          value={6}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[6] do %>Stop Leaderboard<% else %>Start Leaderboard<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[7] do 16 else 7 end}
          value={"streamer"}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[6] do %>Stop Streamer<% else %>Start Streamer<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[8] do 17 else 8 end}
          value={"reader"}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[8] do %>Stop Reader<% else %>Start Reader<% end %>
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[9] do 18 else 9 end}
          value={"Images"}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[9] do %>Stop Images<% else %>Start Images<% end %>
        </button>
      </div>
    </div>
    """
  end
end
