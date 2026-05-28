" Stash entries look like:
"   stash@{0}: On <branch>: <message>
"   stash@{1}: WIP on <branch>: <hash> <message>

" 1. stash@{N}: prefix
syn match gitStashRef /^stash@{\d\+}:/ nextgroup=gitStashOnKeyword skipwhite

" 2. "On" or "WIP on"
syn match gitStashOnKeyword /\(WIP on\|On\)/ contained nextgroup=gitStashBranch skipwhite

" 3. Branch name (up to the next colon)
syn match gitStashBranch /[^:]\+/ contained nextgroup=gitStashColon

" 4. Colon after branch
syn match gitStashColon /:/ contained nextgroup=gitStashHash,gitStashMessage skipwhite

" 5. Optional commit hash (WIP stashes only)
syn match gitStashHash /[a-f0-9]\{4,40\}/ contained nextgroup=gitStashMessage skipwhite

" 6. Message (rest of the line; may contain colons)
syn match gitStashMessage /.*$/ contained

" --- Linking ---
hi def link gitStashRef       Comment
hi def link gitStashOnKeyword Comment
hi def link gitStashColon     Comment
hi def link gitStashBranch    Number
hi def link gitStashHash      Number
hi def link gitStashMessage   Normal
