chalk = require 'chalk'
extend = require 'extend'
program = require 'commander'
defaults = extend {}, require './defaults'
defaults.source = defaults.source.replace process.cwd(),'.'
defaults.dest = defaults.dest.replace process.cwd(),'.'

program
	.version require('../package.json').version
	.option '-s --source [path]', "Path of lcov.info to parse and create a badge for [default: #{chalk.dim defaults.source}]"
	.option '-d --dest [path]', "File path (w/out extenstion) that the generated SVG & PNG badges should be written to [default: #{chalk.dim defaults.dest}]"
	.option '-l --label [label]', "Label of the badge [default: #{chalk.dim defaults.label}]"
	.parse(process.argv)

require('./badge-gen')(program)