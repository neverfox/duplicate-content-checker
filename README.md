Duplicate Content Checker
=========================

Prerequisites
-------------

- Git
- Node.js

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

Documentation
-------------

To view side-by-side annotated documentation of the similarity module:

```
npm install -g docco

docco similarity.litcoffee
```

Then, open `docs/similarity.html` in your browser.

You can also view the documentation in Markdown [here](similarity.litcoffee).
