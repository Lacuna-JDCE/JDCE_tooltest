# JavaScript dead code elimination tools
This script runs several tools that should optimize JavaScript files by removing unused code. It will take the application in the _default/_ folder and run the tool on the main HTML file (default _index.html_) and main JS file (default _js/app.js_). Script files will be extracted from the HTML file for the closure compiler. Rollup and Webpack use the main JS file.
The script outputs a table with the amount of _function_ keywords in the resulting JS source.

## Installation
This test requires Node.js, webpack, rollup and the closure compiler.

## Running
```
./tooltest.sh
```
This should create a folder for each tool. To clean up, run
```
./tooltest.sh clean
```


## Extra
Default test application is from tastejs/todomvc (backbone example)
