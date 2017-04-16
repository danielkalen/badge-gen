Promise = require 'bluebird'
fs = require 'fs-jetpack'
lcovParse = Promise.promisify require 'lcov-parse'
PATH = require 'path'
extend = require 'extend'
axios = require 'axios'
svg2png = require 'svg2png'
defaultOptions = require './defaults'

genBadgeUrl = (label, value, color)->
	"https://img.shields.io/badge/#{encodeURIComponent(label)}-#{encodeURIComponent(value)}-#{color}"


calcCoverage = (lcov)->
	percentages =
		'functions': lcov.functions.hit / lcov.functions.found
		'lines': lcov.lines.hit / lcov.lines.found
	average = (percentages.functions + percentages.lines) / 2
	coverage = (average*100).toString().split('.')[0]+'%'
	percent = parseFloat(coverage)
	color = switch
		when percent is 100 then 'brightgreen'
		when percent > 97 then 'green'
		when percent > 93 then 'yellowgreen'
		when percent > 90 then 'yellow'
		when percent > 85 then 'orange'
		else 'red'
	
	{coverage, color}


module.exports = (options)->
	options = extend({}, defaultOptions, options)
	Promise.resolve()
		.then ()-> fs.inspectAsync(options.dest)
		.then (dest)-> options.dest = PATH.join(options.dest,'coverage') unless dest?.type is 'file' or options.dest.endsWith('coverage')
		.then ()-> fs.dirAsync PATH.join(options.dest,'..')
		.then ()-> lcovParse(options.source)
		.then (parsed)-> calcCoverage(parsed[0])
		.then (values)-> genBadgeUrl(options.label, values.coverage, values.color)
		.then (url)-> axios.get("#{url}.svg").then (res)-> res.data
		.then (svg)-> fs.writeAsync("#{options.dest}.svg", svg)
		.then ()-> fs.readAsync("#{options.dest}.svg", 'buffer')
		.then svg2png
		.then (png)-> fs.writeAsync "#{options.dest}.png", png
		.catch (err)-> throw err














