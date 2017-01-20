Promise = require 'bluebird'
fs = Promise.promisifyAll require 'fs-extra'
fs.createOutputStream = require 'create-output-stream'
lcovParse = Promise.promisify require 'lcov-parse'
PATH = require 'path'
extend = require 'extend'
request = require 'request'
svg2png = require 'svg2png'
defaultOptions = require './defaults'

genBadgeUrl = (label, value, color)->
	"https://img.shields.io/badge/#{encodeURIComponent(label)}-#{encodeURIComponent(value)}-#{color}.svg"


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
	
	fs.statAsync(options.dest)
		.then (destStats)-> options.dest = PATH.join(options.dest,'coverage') unless destStats.isFile()
		.catch ()-> true
		.then ()->
			lcovParse(options.source).then (parsed)->
				values = calcCoverage(parsed[0])
				
				request genBadgeUrl(options.label, values.coverage, values.color)
					.pipe fs.createOutputStream("#{options.dest}.svg")
					
					.on 'finish', (err)-> if err then throw err else
						fs.readFileAsync("#{options.dest}.svg").then (svgBuffer)->
							svg2png(svgBuffer).then (pngBuffer)->
								fs.outputFileAsync "#{options.dest}.png", pngBuffer
		
		.catch (err)-> throw err














