# Hash-based set implementation from the Coffeescript cookbook
# http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
fs = require('fs')
solver = require('./solver')

class NodeSolver
    constructor: (wordfile) ->
        data = fs.readFileSync wordfile
        @solver = new solver.Solver(data)
        @tried = []

    ask: (question, format, callback) ->
        stdin = process.stdin
        stdout = process.stdout
        stdin.resume()
        stdout.write question 
        stdin.once 'data', (data) ->
            data = data.toString().trim()
            if format.test data
                callback data
            else
                stdout.write "It should match: "+ format +"\n"
                ask question, format, callback

    go: ->
        @ask "Input the word with . for blanks: ", /[.a-z]*/, (word) =>
            # DON'T BOTHER CHECKING NOTHING, NOW, Y'HEAR!
            # INPUT IS ALWAYS VALID!
            results = @solver.solve(word, @tried)
            freqs = results.get_letter_freqs()
            possibilities = results.get_possibilities()
            # One left? We've found the word
            if possibilities.length == 1
                console.log "Here it is, bro: #{possibilities}"
                process.exit()
            else
                console.log "Here are the options: #{possibilities.join(" ")}"
                console.log "The most likely next letter is #{freqs[0][1]} (probability: #{100.0 * freqs[0][0] / possibilities.length}%)"
                @tried.push(freqs[0][1])
                @go()

wordfile = '../wordlist.txt'
ns = new NodeSolver(wordfile)
ns.go()
