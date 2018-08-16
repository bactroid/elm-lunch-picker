#!/bin/bash

cp src/index.html dist/index.html
cp src/app.css dist/app.css
elm-make src/App.elm --output=dist/app.js

echo "Project build complete"
