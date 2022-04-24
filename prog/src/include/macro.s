; --- cdecl ---

%macro cdecl 1-*.nolist
    %rep    %0 - 1
        push    %{-1:-1}
        %rotate -1
    %endrep
    %rotate -1

    call    %1

    %if 1 < %0          ; delete args
        add     sp, (__BITS__ >> 3) * (%0 - 1)      ; if realmode then __BITS__ = 16
    %endif
%endmacro
