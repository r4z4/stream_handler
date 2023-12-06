defmodule StreamHandlerWeb.TemplateHelpers do
  def type_icon(type) do
    case type do
      "busywork" -> "👔"
      "charity" -> "🎁"
      "recreational" -> "⚽"
      "social" -> "🥳"
      _ -> "❓"
    end
  end
end
