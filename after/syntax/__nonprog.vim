" Embolden the first word of a paragraph. See original at https://www.reddit.com/r/vim/comments/wg1rbl/embolden_first_word_in_each_new_paragraph/"
highlight __ParaFirstWord gui=bold
syntax match __ParaFirstWord "\%(^$\n*\|\%^\)\@<=\%(^\s*\w\+\)"
