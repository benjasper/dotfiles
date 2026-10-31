#!/bin/sh
jq -r '
  def pct: if . == null then empty else "\(. | round)%" end;
  [
    .model.display_name,
    (.context_window.used_percentage | pct | "ctx \(.)"),
    (.rate_limits.five_hour.used_percentage | pct | "5h \(.)"),
    (.rate_limits.seven_day.used_percentage | pct | "wk \(.)")
  ] | join(" · ")
'
