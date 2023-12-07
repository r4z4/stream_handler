defmodule StreamHandlerWeb.DashboardComponents do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  def activities_card(assigns) do
    ~H"""
    <%= if @activities && Enum.count(@activities.data) > 0 do %>
      <%= StreamHandlerWeb.TemplateHelpers.type_icon(@activities.data.type) %>
      <p>Type: <span><%= @activities.data.type %></span></p>
      <p>Activity: <span><%= @activities.data.activity %></span></p>
    <% end %>
    """
  end

  def slugs_card(assigns) do
    ~H"""
      <h4>Slugs</h4>
      <p>Status: <%= if @text_slugs && Enum.count(@text_slugs) > 0 do %><span>Complete</span><% end %></p>
      <p>Number: <span><%= @number_slugs %></span></p>
      <ul>
        <%= if @text_slugs && Enum.count(@text_slugs) > 0 do %>
          <%= for slug <- @text_slugs do %>
            <li><%= slug %></li>
          <% end %>
        <% end %>
      </ul>
    """
  end

  def emojis_card(assigns) do
    ~H"""
      <h4>Emojis</h4>
      <p>Status: <%= if @emoji && Enum.count(@emoji) > 0 do %><span>Complete</span><% end %></p>
      <%= if @emoji && Enum.count(@emoji) > 0 do %>
        <ul>
          <li><%= @emoji.name %></li>
          <li><%= @emoji.category %></li>
          <li><%= @emoji.group %></li>
          <li><%= @emoji.unicode %></li>
        </ul>
      <% end %>
    """
  end
end
