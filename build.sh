#!/bin/bash

cp src/index.html docs/
cp src/app.css docs/
elm-make src/App.elm --output=docs/app.js

echo "Project build complete"
