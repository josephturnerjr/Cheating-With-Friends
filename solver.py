import re


class Solver(object):
    def __init__(self, worddata):
        # Normalize the word data
        words = set(map(lambda x: x.lower(), worddata.split()))
        # Parse the words into lengths
        lengths = set(map(len, words))
        word_sets = [filter(lambda x: len(x) == l, words) for l in lengths]
        self.words = dict(zip(lengths, word_sets))
        # Keep track of tried letters

    def solve(self, query, tried):
        # Query is . for unknowns, letters filled in as appropriate
        # The words can't contain letters that are already there
        # Also not the letters we've already tried
        bad_chars = set(filter(lambda x: x != '.', query) + "".join(tried))
        # Build a pattern for those letters
        off_limits = "".join(bad_chars)
        ignore_pattern = "[^%s]" % (off_limits,)
        # Replace the wildcards with the pattern
        reg = re.sub('\.', ignore_pattern, query)
        # Words that match the resulting pattern
        possibilities = []
        if len(query) in self.words:
            possibilities = filter(lambda x: re.match(reg, x),
                                   self.words[len(query)])
        return SolverResults(possibilities, bad_chars)

class SolverResults(object):
    def __init__(self, possibilities, bad_chars):
        self.possibilities = possibilities
        self.bad_chars = bad_chars
        self.scores = None

    def get_possibilities(self):
        return self.possibilities

    def get_letter_freqs(self):
        if not self.scores:
            if not self.possibilities:
                self.scores = []
            # Calculate the most likely unguessed letter
            # ALL OF THE LETTERS!
            concat = "".join(self.possibilities)
            # Calculate the letter frequencies for each non-guessed letter,
            #   the max being the most likely
            chars = set(concat) - self.bad_chars
            self.scores = [(len(filter(lambda w: x in w, self.possibilities)), x) for x in chars]
        return self.scores
