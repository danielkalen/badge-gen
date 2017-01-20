# badge-gen
Takes a path to an lcov.info file and generates a [Shields.io](http://shields.io/) badge in both SVG & PNG.

## Usage
```bash
Usage: badge-gen [options]

Options:

  -s --source [path]  Path of lcov.info to parse and create a badge for [default: ./coverage/lcov.info]
  -d --dest [path]    File path (w/out extenstion) that the generated SVG & PNG badges should be written to [default: ./badges/coverage]
  -l --label [label]  Label of the badge [default: coverage]
  -h, --help          output usage information
  -V, --version       output the version number
```