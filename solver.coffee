# Hash-based set implementation from the Coffeescript cookbook
# http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

fs = require('fs')
#process = require('process')

class Solver
    constructor: (wordlist) ->
        data = fs.readFileSync wordlist
        words = new String(data).trim().split(' ')
        words = (x.toLowerCase() for x in words)
        words = words.unique()
        # Parse the words into lengths
        lengths = (w.length for w in words).unique()
        word_sets = (x for x in words when x.length == l for l in lengths)
        @words = {}
        @words[key] = word_sets[i] for key, i in lengths
        console.log @words
        # Keep track of tried letters
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
            if not @solve(word)
                @go()
            else
                process.exit()

    solve: (query) ->
        # Query is . for unknowns, letters filled in as appropriate
        # The words can't contain letters that are already there
        # Also not the letters we've already tried
        bad_chars = (x for x in query when x != '.')
        bad_chars = bad_chars.concat((if @tried.length then @tried.join("") else [])).unique()
        # Build a pattern for those letters
        off_limits = bad_chars.join("")
        ignore_pattern = "[^#{off_limits}]"
        # Replace the wildcards with the pattern
        reg = new RegExp(query.replace /\./g, ignore_pattern)
        # Words that match the resulting pattern
        possibilities = (x for x in @words[query.length] when x.match(reg))
        console.log possibilities
        # One left? We've found the word
        if possibilities.length == 1
            console.log "Here it is, bro: #{possibilities}"
            return true
        else
            # If not, calculate the most likely unguessed letter
            # ALL OF THE LETTERS!
            concat = possibilities.join("").split('')
            # Calculate the letter frequencies for each non-guessed letter,
            #   the max being the most likely
            chars = (x for x in concat.unique() when x not in bad_chars)
#            most_likely = Math.max.apply((concat.count(x), x) for x in chars)[1]
#            print "Here are the options: ", " ".join(possibilities)
#            wf = float(len(filter(lambda x: most_likely in x, possibilities)))
#            likelihood = 100.0 * wf / len(possibilities)
#            print ("The most likely next character is '%s' "
#                  "(probability: %0.2f%%)" % (most_likely, likelihood))
#            @tried.append(most_likely)
#            return False


s = new Solver('test.txt')
s.go()
