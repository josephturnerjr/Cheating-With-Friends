import re


class Solver(object):
    def __init__(self, wordlist="wordlist.txt"):
        with open(wordlist) as wl:
            words = set(map(lambda x: x.lower(), wl.read().split()))
        # Parse the words into lengths
        lengths = set(map(len, words))
        word_sets = [filter(lambda x: len(x) == l, words) for l in lengths]
        self.words = dict(zip(lengths, word_sets))
        # Keep track of tried letters
        self.tried = []

    def go(self):
        while True:
            word = raw_input("Input the word with . for blanks: ")
            # DON'T BOTHER CHECKING NOTHING, NOW, Y'HEAR!
            # INPUT IS ALWAYS VALID!
            if self.solve(word):
                break

    def solve(self, query):
        # Query is . for unknowns, letters filled in as appropriate
        # The words can't contain letters that are already there
        # Also not the letters we've already tried
        bad_chars = set(filter(lambda x: x != '.', query) + "".join(self.tried))
        # Build a pattern for those letters
        off_limits = "".join(bad_chars)
        ignore_pattern = "[^%s]" % (off_limits,)
        # Replace the wildcards with the pattern
        reg = re.sub('\.', ignore_pattern, query)
        # Words that match the resulting pattern
        possibilities = filter(lambda x: re.match(reg, x),
                               self.words[len(query)])
        # One left? We've found the word
        if len(possibilities) == 1:
            print "Here it is, bro: ", possibilities[0]
            return True
        else:
            # If not, calculate the most likely unguessed letter
            # ALL OF THE LETTERS!
            concat = "".join(possibilities)
            # Calculate the letter frequencies for each non-guessed letter,
            #   the max being the most likely
            chars = set(concat) - bad_chars
            most_likely = max((concat.count(x), x) for x in chars)[1]
            print "Here are the options: ", " ".join(possibilities)
            wf = float(len(filter(lambda x: most_likely in x, possibilities)))
            likelihood = 100.0 * wf / len(possibilities)
            print ("The most likely next character is '%s' "
                  "(probability: %0.2f%%)" % (most_likely, likelihood))
            self.tried.append(most_likely)
            return False


def main():
    s = Solver()
    s.go()

if __name__ == '__main__':
    main()
