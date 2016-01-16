# Feihong's Dart Examples

This is a collection of [Dart](https://www.dartlang.org/) example programs.

## Installation

Install dependencies:

```
pip install -r requirements.txt
brew tap dart-lang/dart
brew install dart --with-content-shell --with-dartium
```

Install local JS modules:

```
npm install
```

## Commands

- `invoke serve` - Launch HTTP server that auto-reloads pages when it detects an edit
- `invoke build` - Generate all files and copy them into the build directory
- `invoke clean` - Delete everything inside the build directory
- `invoke publish` - Changes in the build directory are committed and pushed to the gh-pages branch
- `invoke new_page` - Add a new page to the site directory (also adds new entry to webpack config file)
