Duplicate Content Checker
=========================

Demo
----

A [working demo](http://duplicate-content-checker.herokuapp.com/) is available on Heroku.

Prerequisites
-------------

- Git
- Node.js
- JDK (32-bit or 64-bit, according to Node.js version)
- Python 2.x (for node-gyp)

Only tested on Linux. Not guaranteed to build on Windows.

Installation
------------

```
# Clone the repo
git clone https://github.com/neverfox/duplicate-content-checker.git && cd duplicate-content-checker

# Install dependencies
npm install

# Install Mimosa build system
npm install -g mimosa

# Build
mimosa build -mop

# Launch
cd dist && node app.js
```

Then, open `localhost:3000` in your browser.

Documentation
-------------

To view side-by-side annotated documentation of the similarity module:

```
npm install -g docco

docco similarity.litcoffee
```

Then, open `docs/similarity.html` in your browser.

You can also view the documentation in Markdown [here](similarity.litcoffee).
