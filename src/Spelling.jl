__precompile__()
module Spelling
using DataStructures
using StringDistances

export score, spellcheck, spellcheck_sentence, correct, correct_sentence

const dir = Pkg.dir("Spelling")
const linuxwords = Set(readlines("$dir/data/words"))
include("$dir/data/guten.jl")
include("$dir/data/tv.jl")

#Uppercase/lowercase isn't very well-supported, though there are some cased words in the
# lists, such as country names and pronouns, hence why no automatic lowercase is being performed

const formality = 0.6
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
    words[(w->!spellcheck(w.match, c)).(words)]
end

function correct_tv(s::String)
    ks = [keys(tv)...]
    ns = (x->StringDistances.compare(DamerauLevenshtein(), x, s)).(ks)
    ks[indmax(ns)]
end

function correct_guten(s::String)
    ks = [keys(guten)...]
    ns = (x->StringDistances.compare(DamerauLevenshtein(), x, s)).(ks)
    ks[indmax(ns)]
end

function correct(s::String, f=formality)
    tks = [keys(tv)...]
    gks = [keys(guten)...]
    tns = (x->StringDistances.compare(DamerauLevenshtein(), x, s)).(tks)
    gns = (x->StringDistances.compare(DamerauLevenshtein(), x, s)).(gks)
    tm, gm = indmax(tns), indmax(gns)
    if (1-f)*tns[tm] == f*gns[gm]
        tv[tks[tm]] > guten[gks[gm]] ? tks[tm] : gks[gm]
    else
        (1-f)*tns[tm] > f*gns[gm] ? tks[tm] : gks[gm]
    end
end

function correct_sentence(s::String, f=formality)
    words = String.((x->x.match).(collect(eachmatch(r"\w+", s))))
    sn = split(s, r"\w+")
    nw = [correct.(words, f); ""]
    join(sn.*nw)
end

end
