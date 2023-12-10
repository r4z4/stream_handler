defmodule StreamHandlerWeb.DashboardComponents do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  def activities_card(assigns) do
    ~H"""
    <div class="relative">
      <h4>Activities</h4>
      <div class="absolute top-0 right-0"><%= if @activities && Enum.count(@activities) > 0 do %><span class="text-xs">🟢</span><% else %>🔴<% end %></div>
      <%= if @activities && Enum.count(@activities) > 0 do %>
        <%= StreamHandlerWeb.TemplateHelpers.type_icon(@activities.type) %>
        <p>Type: <span><%= @activities.type %></span></p>
        <p>Activity: <span><%= @activities.activity %></span></p>
      <% end %>
    </div>
    """
  end

  def slugs_card(assigns) do
    ~H"""
    <div class="relative">
      <h4>Slugs</h4>
      <div class="absolute top-0 right-0"><%= if @slugs && Enum.count(@slugs) > 0 do %><span class="text-xs">🟢</span><% else %>🔴<% end %></div>
      <ul>
        <%= if @slugs && Enum.count(@slugs) > 0 do %>
          <%= for slug <- @slugs do %>
            <li><%= slug %></li>
          <% end %>
        <% end %>
      </ul>
    </div>
    """
  end

  def emojis_card(assigns) do
    ~H"""
      <div class="relative">
        <div class="absolute top-0 left-0"><h4>Emojis</h4></div>
        <div class="absolute top-0 right-0"><%= if @emojis && Enum.count(@emojis) > 0 do %><span class="text-sm">🟢</span><% else %>🔴<% end %></div>
        <%= if @emojis && Enum.count(@emojis) > 0 do %>
          <ul>
            <li><%= @emojis.name %></li>
            <li><%= @emojis.category %></li>
            <li><%= @emojis.group %></li>
            <li><%= @emojis.unicode %></li>
          </ul>
        <% end %>
      </div>
    """
  end

  # FIXME @ets.string
  def ets_card(assigns) do
    ~H"""
      <div class="relative">
        <div class="absolute top-0 left-0"><h4>ETS</h4></div>
        <div class="absolute top-0 right-0"><%= if @ets && Enum.count(@ets) > 0 do %><span>🟢</span><% else %>🔴<% end %></div>
        <%= if @ets && Enum.count(@ets) > 0 do %>
          <table>
          <colgroup>
            <col />
            <col style="background-color: #add8e6" />
            <col />
          </colgroup>
          <tr>
            <th>User</th>
            <th>Score</th>
            <th>Joined</th>
          </tr>
          <%= for score <- @ets.string do %>
            <tr>
              <th><%= score.username %></th>
              <th><%= score.score %></th>
              <th><%= score.joined %></th>
            </tr>
          <% end %>
          </table>
        <% end %>
      </div>
    """
  end

  def reader_card(assigns) do
    ~H"""
      <div class="relative">
        <div class="absolute top-0 left-0"><h4>Reader</h4></div>
        <div class="absolute top-0 right-0"><%= if @reader && Enum.count(@reader) > 0 do %><span>🟢</span><% else %>🔴<% end %></div>
        <div class="shrink">
          <%= if @reader && Enum.count(@reader) > 0 do %>
              <p><%= @reader.string %></p>
          <% end %>
        </div>
      </div>
    """
  end

  def images_card(assigns) do
    ~H"""
      <div class="relative">
        <div class="absolute top-0 left-0"><h4>Images</h4></div>
        <div class="absolute top-0 right-0"><%= if @images && Enum.count(@images) > 0 do %><span>🟢</span><% else %>🔴<% end %></div>
        <%= if @images && Enum.count(@images) > 0 do %>
            <img width="200" height="300" src={@images.string} />
        <% end %>
      </div>
    """
  end

  def kraken_card(assigns) do
    ~H"""
      <div class="relative">
        <div class="absolute top-0 left-0"><h4>Kraken</h4></div>
        <div class="absolute top-0 right-0"><%= if @streams.messages do %><span>🟢</span><% else %>🔴<% end %></div>
        <div id="messages" phx-update="stream" class="w-fit h-fit">
          <div :for={{dom_id, message} <- @streams.messages} id={dom_id}>
            <p><%= message.id %> -> <%= message.data["c"] %></p>
          </div>
        </div>

        <div id="spreads" phx-update="stream" class="w-fit">
          <div :for={{dom_id, message} <- @streams.spreads} id={dom_id}>
            <p><%= message.id %> -> <%= message.data %></p>
          </div>
        </div>
      </div>
    """
  end

  def streamer_card(assigns) do
    ~H"""
    <div class="relative">
      <div class="absolute top-0 left-0"><h4>Streamer</h4></div>
      <div class="absolute top-0 right-0"><%= if @streamer_svg do %><span>🟢</span><% else %>🔴<% end %></div>
      <svg viewBox="0 0 56 18">
        <%= if @streamer_svg do %><%= @streamer_svg %><% end %>
      </svg>
    </div>
    """
  end
end
