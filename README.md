# JavaScript dead code elimination tools
This script runs several tools that should optimize JavaScript files by removing unused code. It will take the application in the _default/_ folder and run the tool on the main HTML file (default _index.html_) and main JS file (default _js/app.js_). Script files will be extracted from the HTML file for the closure compiler. Rollup and Webpack use the main JS file.
The script outputs a table with the amount of _function_ keywords in the resulting JS source and the number of JS errors, if any.

Depending on your machine's speed, you might want to increase the _chrome_timeout_ value in _tooltest.sh_.

## Installation
Requires the following:
+ Chromium (`chromium-browser`)
+ Node.js (`nodejs-legacy`)
+ Google closure compiler (`closure-compiler`)
+ Xvfb (`xvfb`)

And the following npm modules:
+ webpack (`webpack`)
+ rollup (`rollup`)



## Running
```
./tooltest.sh
```
This should create a folder for each tool. To remove all created folders, run
```
./tooltest.sh clean
```
