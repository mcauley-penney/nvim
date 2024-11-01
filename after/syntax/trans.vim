if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "trans"

" Syntax groups
syntax match TransComment "\v//.*"
syntax match TransSpeaker "\v\s*\zs[A-Z]\w+:\ze\s"
syntax match TransTime "\v[0-9]{2}:[0-9]{2}(.[0-9]{3})?"
syntax match TransTimeDelta "\v\s\-\-\>"
syntax match TransTimeBlock "\v(^\[|])"

" Highlighting definitions
highlight link TransComment Comment
highlight link TransSpeaker Operator
highlight link TransTime Keyword
highlight link TransTimeBlock Keyword
highlight link TransTimeDelta Comment
