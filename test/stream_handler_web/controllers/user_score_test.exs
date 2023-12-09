defmodule StreamHandlerWeb.UserScoreTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias StreamHandler.Streams.UserScore

  defp naive_dt_generator do
    gen all year <- StreamData.integer(2000..2023),
            month <- StreamData.integer(1..12),
            day <- StreamData.integer(1..28) do
        NaiveDateTime.new!(year, month, day, 0, 0, 0)
    end
  end

  describe "Property Tests" do
    property "bin1 <> bin2 always starts with bin1" do
      check all bin1 <- binary(),
                bin2 <- binary() do
        assert String.starts_with?(bin1 <> bin2, bin1)
      end
    end

    property "struct! macro correctly translates UserScore struct" do
      check all username <- binary(),
                score <- integer(),
                joined <- naive_dt_generator() do
        assert struct!(UserScore, %{username: username, score: score, joined: joined}) == %UserScore{username: username, score: score, joined: joined}
      end
    end
  end
end
