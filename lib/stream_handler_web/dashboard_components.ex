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
end
