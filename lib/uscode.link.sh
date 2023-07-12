#!/bin/env bash

index="cache/uscode.house.gov/statutes/source.index.json"
echo "[" > $index
for node in $(find cache/uscode.house.gov/ -name '*.html'); do
  ruby -r nokogiri -r json ./uscode.link.rb "$node" >> $index
done
echo "\n]" >> $index
