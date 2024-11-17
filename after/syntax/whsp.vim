" See filetype.lua for the code that adds this ft

if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "whsp"

" Syntax groups
syntax match WhspComment "\v//.*"
syntax match WhspSpeaker "\v\s*\zs[A-Z]\w+:\ze\s"
syntax match WhspTime "\v[0-9]{2}:[0-9]{2}(.[0-9]{3})?"
syntax match WhspTimeDelta "\v\s\-\-\>"
syntax match WhspTimeBlock "\v(^\[|])"

" Highlighting definitions
highlight link WhspComment Comment
highlight link WhspSpeaker Operator
highlight link WhspTime Keyword
highlight link WhspTimeBlock Keyword
highlight link WhspTimeDelta Comment
