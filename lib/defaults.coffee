PATH = require 'path'

module.exports = 
	dest: PATH.resolve 'badges','coverage'
	source: PATH.resolve 'coverage','lcov.info'
	label: 'coverage'