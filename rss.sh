#!/bin/bash
set -euo pipefail

word_id="${1:?specify news word id}"
link="https://www3.nhk.or.jp/news/word/${word_id}.html"
root_link="https://www3.nhk.or.jp"
json_link="https://www3.nhk.or.jp/news/json16/word/${word_id}_001.json?_=$(date +%s)"

curl -sfL "$json_link" | jq --raw-output --arg link "$link" --arg root_link "$root_link" \
  '"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<rss version=\"2.0\">
<channel>
<title>\(.channel.word|@html)</title>
<link>\($link)</link>
<description></description>
\(.channel.item |
  map("<item><title>\(.title|@html)</title><link>\($root_link + .link)</link><pubDate>\(.pubDate)</pubDate></item>") |
  join("\n"))
</channel>
</rss>"'

