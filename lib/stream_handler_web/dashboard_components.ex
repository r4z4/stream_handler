defmodule StreamHandlerWeb.DashboardComponents do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  def activities_card(assigns) do
    ~H"""
    <%= if @activities && Enum.count(@activities) > 0 do %>
      <%= StreamHandlerWeb.TemplateHelpers.type_icon(@activities.type) %>
      <p>Type: <span><%= @activities.type %></span></p>
      <p>Activity: <span><%= @activities.activity %></span></p>
    <% end %>
    """
  end

  def slugs_card(assigns) do
    ~H"""
      <h4>Slugs</h4>
      <p>Status: <%= if @slugs && Enum.count(@slugs) > 0 do %><span>Complete</span><% end %></p>
      <ul>
        <%= if @slugs && Enum.count(@slugs) > 0 do %>
          <%= for slug <- @slugs do %>
            <li><%= slug %></li>
          <% end %>
        <% end %>
      </ul>
    """
  end

  def emojis_card(assigns) do
    ~H"""
      <h4>Emojis</h4>
      <p>Status: <%= if @emojis && Enum.count(@emojis) > 0 do %><span>Complete</span><% end %></p>
      <%= if @emojis && Enum.count(@emojis) > 0 do %>
        <ul>
          <li><%= @emojis.name %></li>
          <li><%= @emojis.category %></li>
          <li><%= @emojis.group %></li>
          <li><%= @emojis.unicode %></li>
        </ul>
      <% end %>
    """
  end

  # FIXME @ets.string
  def ets_card(assigns) do
    ~H"""
      <h4>ETS</h4>
      <p>Status: <%= if @ets && Enum.count(@ets) > 0 do %><span>Complete</span><% end %></p>
      <%= if @ets && Enum.count(@ets) > 0 do %>
        <%= for score <- @ets.string do %>
          <li><%= score.username %> || <%= score.score %> || <%= score.joined %></li>
        <% end %>
      <% end %>
    """
  end

  def reader_card(assigns) do
    ~H"""
      <h4>Reader</h4>
      <p>Status: <%= if @reader && Enum.count(@reader) > 0 do %><span><%= @reader.status %></span><% end %></p>
      <%= if @reader && Enum.count(@reader) > 0 do %>
          <p><%= @reader.string %></p>
      <% end %>
    """
  end

  def images_card(assigns) do
    ~H"""
      <h4>Images</h4>
      <p>Status: <%= if @images && Enum.count(@images) > 0 do %><span><%= @images.status %></span><% end %></p>
      <%= if @images && Enum.count(@images) > 0 do %>
          <img width="200" height="300" src={@images.string} />
      <% end %>
    """
  end

  def kraken_card(assigns) do
    ~H"""
      <div>
        <h3>Kraken</h3>
        <div id="messages" phx-update="stream">
          <div :for={{dom_id, message} <- @streams.messages} id={dom_id}>
            <p><%= message.id %> -> <%= message.data["c"] %></p>
          </div>
        </div>

        <div id="spreads" phx-update="stream">
          <div :for={{dom_id, message} <- @streams.spreads} id={dom_id}>
            <p><%= message.id %> -> <%= message.data %></p>
          </div>
        </div>
      </div>
    """
  end

  def streamer_card(assigns) do
    ~H"""
    <div>
      <%= if @streamer_svg do %><%= @streamer_svg %><% end %>
    </div>
    """
  end
end
