defmodule StreamHandlerWeb.TemplateHelpers do
  def type_icon(type) do
    case type do
      "busywork" -> "👔"
      "charity" -> "🎁"
      "recreational" -> "⚽"
      "social" -> "🥳"
      "education" -> "📚"
      _ -> "❓"
    end
  end
end
