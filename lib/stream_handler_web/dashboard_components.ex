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
