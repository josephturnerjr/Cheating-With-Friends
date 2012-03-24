# Hash-based set implementation from the Coffeescript cookbook
# http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

class Solver
    constructor: (data) ->
        words = new String(data).trim().split(' ')
        words = (x.toLowerCase() for x in words)
        words = words.unique()
        # Parse the words into lengths
        lengths = (w.length for w in words).unique()
        word_sets = (x for x in words when x.length == l for l in lengths)
        @words = {}
        @words[key] = word_sets[i] for key, i in lengths
        # Keep track of tried letters

    solve: (query, tried) ->
        # Query is . for unknowns, letters filled in as appropriate
        # The words can't contain letters that are already there
        # Also not the letters we've already tried
        bad_chars = (x for x in query when x != '.')
        bad_chars = bad_chars.concat((if tried.length then tried.join("") else [])).unique()
        # Build a pattern for those letters
        off_limits = bad_chars.join("")
        ignore_pattern = "[^#{off_limits}]"
        # Replace the wildcards with the pattern
        reg = new RegExp(query.replace /\./g, ignore_pattern)
        # Words that match the resulting pattern
        possibilities = (x for x in @words[query.length] when x.match(reg))
        return new SolverResults(possibilities, bad_chars)


class SolverResults
    constructor: (possibilities, bad_chars) ->
        @possibilities = possibilities
        @bad_chars = bad_chars
        
    get_possibilities: ->
        return @possibilities

    get_letter_freqs: ->
        if not @scores?
            # Calculate the most likely unguessed letter
            # ALL OF THE LETTERS!
            concat = @possibilities.join("").split('')
            # Calculate the letter frequencies for each non-guessed letter,
            #   the max being the most likely
            chars = (x for x in concat.unique() when x not in @bad_chars)
            @scores = ([(y for y in concat when y == x).length, x] for x in chars)
            @scores.sort((a,b) -> b[0] - a[0])
        return @scores
