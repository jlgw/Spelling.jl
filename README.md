# Spelling
[![Build Status](https://travis-ci.org/lancebeet/Spelling.jl.svg?branch=master)](https://travis-ci.org/lancebeet/Spelling.jl)

[![Coverage Status](https://coveralls.io/repos/lancebeet/Spelling.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/lancebeet/Spelling.jl?branch=master)

[![codecov.io](http://codecov.io/github/lancebeet/Spelling.jl/coverage.svg?branch=master)](http://codecov.io/github/lancebeet/Spelling.jl?branch=master)

Spelling package for use in other projects.

```julia

julia> using Spelling

julia> spellcheck("fish")
true

julia> score("fish")
57229.76679608938

julia> spellcheck_sentence("the quick bronw fox jumped over the laxy dog")
2-element Array{RegexMatch,1}:
 RegexMatch("bronw")
 RegexMatch("laxy")

julia> correct("speilng")
"spelling"

julia> correct("matlab")
"atlas"
```
