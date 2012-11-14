;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

[org 0x00711000]

;_str_version: db "3.03p4 B6 ",0
_str_version: db "3.03p-iran ",0

;format_test_str  db 'SC%c%02d%c%c.INI',0
test_str  db "RUN1226M",0

%include "config.inc"
%include "imports.inc"
%include "string.inc"

; generic
%include "src/arguments.asm"
%include "src/expansions.asm"
%include "src/music_loading.asm"
%include "src/movie_loading.asm"
;%include "src/spawn.asm"

%ifdef USE_NOCD
%include "src/nocd.asm"
%endif

%ifdef USE_EXCEPTIONS
%include "src/exception.asm"
%endif

%ifdef USE_BUGFIXES
%include "src/max_units_bug.asm"
%include "src/fence_bug.asm"
%include "src/tags_bug.asm"
%include "src/savegame_bug.asm"
%endif

%ifdef USE_HIRES
%include "src/hires.asm"
%endif

%ifdef USE_NEW_MULTIPLAYER_DEFAULTS
%include "src/multiplayer_defaults.asm"
%endif

%ifdef USE_LOAD_MORE_MIX_FILES
%include "src/load_more_mix_files.asm"
%endif
