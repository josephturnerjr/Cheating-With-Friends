import solver

class CLSolver(object):
    def __init__(self, wordlist):
        with open(wordlist) as wl:
            worddata = wl.read()
        self.solver = solver.Solver(worddata)
        self.tried = []

    def ask(self, question):
        return raw_input(question)
        

    def go(self):
        while True:
            word = self.ask("Input the word with . for blanks: ")
            # DON'T BOTHER CHECKING NOTHING, NOW, Y'HEAR!
            # INPUT IS ALWAYS VALID!
            results = self.solver.solve(word, self.tried)
            freqs = results.get_letter_freqs()
            possibilities = results.get_possibilities()
            # One left? We've found the word
            if len(possibilities) == 1:
                print "Here it is, bro: %s" % (possibilities,)
                return
            else:
                print "Here are the options: %s" % (" ".join(possibilities))
                print "The most likely next letter is %s (probability: %0.2f%%)" % (freqs[0][1], 100.0 * freqs[0][0] / len(possibilities))
                self.tried.append(freqs[0][1])
                self.go()


def main():
    wordlist = "../wordlist.txt"
    CLSolver(wordlist).go()

if __name__ == '__main__':
    main()
