# JavaScript dead code elimination tools
This script runs several tools that should optimize JavaScript files by removing unused code. It will take the application in the _default_ folder and run the tool on the main HTML file (default _index.html_) and main JS file (default _js/app.js_). Script files will be extracted from the HTML file for the closure compiler. Rollup and Webpack use the main JS file.


## Installation
This test requires Node.js, webpack, rollup and the closure compiler.
```
sudo apt-get install nodejs
npm install webpack -g
npm install rollup -g
apt-get install closure-compiler
```

## Running
```
./test.sh
```
This should create a folder for each tool.


## Extra
Default test application is from tastejs/todomvc (backbone example)
