defmodule StreamHandlerWeb.DashboardComponents do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  @spec unicode_display([binary()]) :: binary()
  def unicode_display(unicode) do
    str = String.replace(Enum.at(unicode, 0), "U+", "\\u")
    # List.to_string ["\x{1F54C}"]
    List.to_string [str]
  end
  def activities_card(assigns) do
    ~H"""
    <div class="relative flex">
      <div class="justify-self-start"><h4>Activities</h4></div>
      <div class="justify-self-end"><span class="text-xs"><%= if @activities && Enum.count(@activities) > 0 do %>🟢<% else %>🔴<% end %></span></div>
      <%= if @activities && Enum.count(@activities) > 0 do %>
        <div class="self-center">
          <%= StreamHandlerWeb.TemplateHelpers.type_icon(@activities.type) %>
          <p>Type: <span><%= String.capitalize(@activities.type) %></span></p>
          <p>Activity: <span><%= @activities.activity %></span></p>
        </div>
      <% end %>
    </div>
    """
  end

  def slugs_card(assigns) do
    ~H"""
    <div class="relative flex">
      <div class="justify-self-start"><h4>Slugs</h4></div>
      <div class="justify-self-end"><span class="text-xs"><%= if @slugs && Enum.count(@slugs) > 0 do %>🟢<% else %>🔴<% end %></span></div>
      <ul class="columns-2 self-center">
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
      <div class="relative flex">
        <div class="justify-self-start"><h4>Emojis</h4></div>
        <div class="justify-self-end"><span class="text-sm"><%= if @emojis && Enum.count(@emojis) > 0 do %>🟢<% else %>🔴<% end %></span></div>
        <%= if @emojis && Enum.count(@emojis) > 0 do %>
          <ul class="self-center">
            <li><%= String.capitalize(@emojis.name) %></li>
            <li><%= String.capitalize(@emojis.category) %></li>
            <li><%= String.capitalize(@emojis.group) %></li>
            <li><%= @emojis.unicode %></li>
            <li><%= unicode_display(@emojis.unicode) %></li>
          </ul>
        <% end %>
      </div>
    """
  end

  # FIXME @ets.string
  def ets_card(assigns) do
    ~H"""
      <div class="relative flex">
        <div class="justify-self-start"><h4>ETS</h4></div>
        <div class="justify-self-end"><span class="text-xs"><%= if @ets && Enum.count(@ets) > 0 do %>🟢<% else %>🔴<% end %></span></div>
        <%= if @ets && Enum.count(@ets) > 0 do %>
          <table style="border-spacing: 10px 0; border-collapse: separate;" class="justify-center text-sm leading-3">
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
              <td><%= score.username %></td>
              <td class="ml-4"><%= score.score %></td>
              <td class="ml-4"><%= score.joined %></td>
            </tr>
          <% end %>
          </table>
        <% end %>
      </div>
    """
  end

  def reader_card(assigns) do
    ~H"""
      <div class="relative flex">
        <div class="justify-self-start"><h4>Reader</h4></div>
        <div class="justify-self-end"><span class="text-xs"><%= if @reader && Enum.count(@reader) > 0 do %>🟢<% else %>🔴<% end %></span></div>
        <div class="shrink justify-self-center self-center">
          <%= if @reader && Enum.count(@reader) > 0 do %>
              <p><%= @reader.string %></p>
          <% end %>
        </div>
      </div>
    """
  end

  def images_card(assigns) do
    ~H"""
      <div class="relative flex">
        <div class="justify-self-start"><h4>Images</h4></div>
        <div class="justify-self-end"><span class="text-xs"><%= if @images && Enum.count(@images) > 0 do %>🟢<% else %>🔴<% end %></span></div>
        <%= if @images && Enum.count(@images) > 0 do %>
            <img width="200" height="300" src={@images.string} />
        <% end %>
      </div>
    """
  end

  def kraken_card(assigns) do
    ~H"""
      <div class="relative flex">
        <div class="justify-self-start"><h4>Kraken</h4></div>
        <div class="justify-self-end"><span class="text-xs"><%= if @streams.messages && Enum.count(@streams.messages) > 0 do %>🟢<% else %>🔴<% end %></span></div>
        <div class="justify-self-start self-center">
          <div id="messages" phx-update="stream" class="w-fit h-fit">
            <div :for={{dom_id, message} <- @streams.messages} id={dom_id}>
              <p>Checksum -> <%= message.data["c"] %></p>
            </div>
          </div>

          <div id="spreads" phx-update="stream" class="w-fit">
            <div :for={{dom_id, message} <- @streams.spreads} id={dom_id}>
              <p>Bid -> <%= Enum.at(message.data, 0) %></p>
              <p>Ask -> <%= Enum.at(message.data, 1) %></p>
              <p>Time -> <%= Enum.at(message.data, 2) %></p>
            </div>
          </div>
        </div>
      </div>
    """
  end

  def streamer_card(assigns) do
    ~H"""
    <div class="relative flex">
      <div class="justify-self-start"><h4>Streamer</h4></div>
      <div class="justify-self-end"><span class="text-xs"><%= if @streamer_svg do %>🟢<% else %>🔴<% end %></span></div>
      <svg viewBox="0 0 56 18">
        <%= if @streamer_svg do %><%= @streamer_svg %><% end %>
      </svg>
    </div>
    """
  end
end
