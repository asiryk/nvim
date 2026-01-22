" 1. Graph (Start of line)
syn match gitLgGraph /^[|/\\_* ]\+/ nextgroup=gitLgHash skipwhite

" 2. Commit Hash
syn match gitLgHash /[a-f0-9]\{4,40\}/ contained nextgroup=gitLgDecoration,gitLgMessage skipwhite

" 3. Decorations (The parens)
" We define the region, containing our 3 groups
syn region gitLgDecoration start="(" end=")" contained contains=gitLgHead,gitLgTag,gitLgBranch nextgroup=gitLgMessage skipwhite

" --- Inner Decoration Matches ---

" HEAD -> ...
" Matches the whole arrow sequence
syn match gitLgHead /HEAD -> [a-zA-Z0-9_\.\-/]\+/ contained

" tag: ...
" Matches the tag prefix and the version
syn match gitLgTag /tag: [a-zA-Z0-9_\.\-/]\+/ contained

" Branch (Catch-all)
" \<\(HEAD\|tag\)\@! : Negative Lookahead.
" If the word starts with "HEAD" or "tag", this match FAILS immediately.
" This forces Vim to use gitLgHead or gitLgTag instead.
syn match gitLgBranch /\<\(HEAD\|tag\)\@![a-zA-Z0-9_\.\-/]\+\>/ contained

" 4. Commit Message
" Safety: Don't match if we see an opening parenthesis
syn match gitLgMessage /\(\s*(\)\@!.\{-}\ze\s*<[a-zA-Z]/ contained

" 5. Meta Block <Date | Author>
syn match gitLgMeta /<[^>]*>$/ contains=gitLgAuthor

" 6. Author Name
syn match gitLgAuthor /| \zs[^>]\+/ contained

" --- Linking ---
hi def link gitLgGraph    Comment
hi def link gitLgHash     Number
hi def link gitLgDecoration Comment

hi def link gitLgHead     Keyword
hi def link gitLgTag      Constant
hi def link gitLgBranch   Type

hi def link gitLgMessage  Normal
hi def link gitLgMeta     Comment
hi def link gitLgAuthor   Identifier
