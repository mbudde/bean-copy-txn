if exists("b:did_ftplugin") && b:did_ftplugin != 1
    finish
endif

let s:bean_copy_txn_exec = expand("<sfile>:h") . '/../bin/target/release/bean-copy-txn'

function! s:insert_transaction(result)
    let insert_lnr = line('.')
    let insert_parts = split(getline(insert_lnr), ' ')
    let date = strftime("%Y-%m-%d")
    if len(insert_parts) > 0
        let date = date[:-len(insert_parts[0])-1] . insert_parts[0]
    endif

    let parts = split(a:result, ' ', 1)
    if parts[0] ==# '-1'
        let parts[1] = date
        call setline(insert_lnr, join(parts[1:], ' '))
    else
        let tx = system([s:bean_copy_txn_exec, expand('%'), parts[0]])
        let lines = split(tx, "\n")
        let first_line = substitute(lines[0], '^[^ ]\+', date, "")
        call cursor(insert_lnr, 0)
        call setline(insert_lnr, first_line)
        call append(insert_lnr, lines[1:] + [""])
        norm j$BB
    end
    normal f"l
endfunction

function! s:transaction_lines()
    let lines = reverse(systemlist([s:bean_copy_txn_exec, expand('%')]))
    call insert(lines, '-1 ' . strftime("%Y-%m-%d") . ' * ""')
    return lines
endfunction

command! -nargs=0 CopyTransaction call fzf#run({
            \ 'source': s:transaction_lines(),
            \ 'sink': function("s:insert_transaction"),
            \ 'options': ['--no-multi', '--with-nth=2..'],
            \ 'down': '30%',
            \ })

inoremap <buffer> <C-t> <C-\><C-O>:CopyTransaction<CR>
nnoremap <buffer> <C-t> :CopyTransaction<CR>
