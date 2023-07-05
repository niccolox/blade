#!/bin/env bash

for node in $(find cache/uscode.house.gov/ -name '*.html' | tail -n 12); do
  ruby -r nokogiri -r json -e \
    "puts Nokogiri::XML(File.read(ARGV[0])).search('a').map { |a|
    { addr: File.join('https://uscode.house.gov', a['href']), label: a.parent.text }}.to_json" \
    "$node" > cache/uscode.house.gov/statutes/source.index.json
done
