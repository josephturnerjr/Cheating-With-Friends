all:
	cp ../wordlist.txt .
	coffee -c -j plugins.js -o js/ ../solver.coffee cheatwidget.coffee
	coffee -c -j script.js -o js/ cheatscript.coffee

run:
	python -m SimpleHTTPServer
