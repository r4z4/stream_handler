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
    <div class="grid grid-rows-3 grid-flow-col gap-4">
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={1}
          value={1}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Slugs Service
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={2}
          value={2}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Emojis Service
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={3}
          value={3}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Service #3
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={4}
          value={4}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Service #4
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={5}
          value={5}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Get All Services
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={6}
          value={6}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Service #6
        </button>
      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={9}
          value={9}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Service #7
        </button>
      </div>
      <div>


        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={if @clicked_map && @clicked_map[8] do 17 else 8 end}
          value={17}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        ><%= if @clicked_map && @clicked_map[8] do %>Stop #7<% else %>Start #7<% end %>
        </button>


      </div>
      <div>
        <button
          type="button"
          phx-click="service_casted"
          phx-value-id={9}
          value={9}
          class="inline-block rounded border-2 border-success w-3/3 px-2 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-success transition duration-150 ease-in-out hover:border-success-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-success-600 focus:border-success-600 focus:text-success-600 focus:outline-none focus:ring-0 active:border-success-700 active:text-success-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10"
        >Service #8
        </button>
      </div>
    </div>
    """
  end
end
