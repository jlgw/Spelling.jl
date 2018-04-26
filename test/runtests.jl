using Spelling
using Base.Test

@test spellcheck("radio") == true 
@test spellcheck("aklsdfjlak") == false 
@test score("test") > 5000
@test (w->w.match).(spellcheck_sentence("fox house spoon asdkflj horse")) == ["asdkflj"]
