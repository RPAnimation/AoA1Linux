; Listing 7-2
;
; Gas does not support local symbols like MASM does.
; So this sample program cannot be converted to Gas.
;
; Demonstration of local symbols #2.
; Note that this program will not
; compile; it fails with two
; undefined symbol errors.

        option  casemap:none

        
            .code

hasLocalLbl proc

localStmLbl:
            option noscoped
notLocal:
            option scoped
isLocal:
            ret
hasLocalLbl endp


; Here is the "asmMain" function.

        
asmMain     proc

            lea     rcx, localStmtLbl  ;Generates an error
            lea     rcx, notLocal      ;Assembles fine
            lea     rcx, isLocal       ;Generates an error
asmMain     endp
            end