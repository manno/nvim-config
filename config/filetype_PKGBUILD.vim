
let g:neomake_sh_shellcheck_maker = {
        \ 'args': ['-fgcc', '-e', 'SC2034,SC2148,SC2164,SC2086,SC2154'],
        \ 'errorformat':
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m',
    \ }

au BufEnter PKGBUILD setf sh
au BufEnter PKGBUILD Neomake
au BufEnter PKGBUILD syn match error /$(.*)/
au BufEnter PKGBUILD syn match error /`.*`/
au BufEnter PKGBUILD syn match error "source="
au BufEnter PKGBUILD syn match error !\(.profile\|.bash_profile\|.config/systemd/user\|.local/share/dbus/services\|.config/autostart\)!
au BufEnter PKGBUILD syn match error ":()"
au BufEnter PKGBUILD syn match error "| sh"
au BufEnter PKGBUILD syn match error /\(wget\|curl\|pip\|base64\|xxd\) /
au BufEnter PKGBUILD syn match error /\(ord(\)/
