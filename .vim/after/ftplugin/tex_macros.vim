
"---------------------------------------------------------------"
" macros that need to be overwritten b/c they are set by plugin "
"---------------------------------------------------------------"

" `w makes \omega instead of \wedge
call IMAP('`w', '\omega', 'tex')

" change section commands to use starred version
call IMAP('SSE', '\section*{<++>}', 'tex')
call IMAP('SSS', '\subsection*{<++>}', 'tex')
call IMAP('SS2', '\subsubsection*{<++>}', 'tex')

call IMAP('`(', '\subseteq ', 'tex')
call IMAP('`)', '\supseteq ', 'tex')
call IMAP('`0', '\emptyset', 'tex')
