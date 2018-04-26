__precompile__()
module Spelling
using DataStructures

export score, spellcheck, spellcheck_sentence

dir = Pkg.dir("Spelling")
include("$dir/data/guten.jl")
include("$dir/data/tv.jl")
linuxwords = Set(readlines("$dir/data/words"))

const formality = 0.5
const cutoff    = 0.5
"""
score(s)

Scores a given word in terms of how common it is. A value of 1 means it is a member of the
linux.words file provided with fedora 26, a higher value is its relative frequency per
billion words in text, based on the ~40,000 most common words from project Gutenberg
and the ~40,000 most common words from TV show scripts (both from Wikipedia).
"""
function score(s)
    g = s∈ keys(guten) ? guten[s] : 0.0
    t = s∈ keys(tv) ? tv[s] : 0.0
    l = s∈ linuxwords ? 1 : 0
    sqrt(formality*g^2 + (1-formality)*t^2 + l)
end

"""
spellcheck(s, c=cutoff)

Returns true if a word scores above the cutoff value (i.e. is a word) and false otherwise.
"""
spellcheck(s, c=cutoff) = score(s) >= c

"""
spellcheck_sentence(s::String, c=cutoff)

Spellchecks a sentence and returns regex matches for the failing words.
"""
function spellcheck_sentence(s::String, c=cutoff)
    words = collect(eachmatch(r"\w+", s))
    words[(w->!spellcheck(w.match)).(words)]
end

end
