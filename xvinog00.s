; Autor reseni: Alina Vinogradova xvinog00
; xvinog00-r1-r2-r10-r12-r23-r0

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xvinog00"
cipher:         .space 17

params_sys5:    .space 8
                .text

main:
                addi r10, r0, 97        ; r10 = hranice abecedy, ascii 'a'(97)
                lb r1, login(r12)       ; r12 = index pole login, r1 = pismeno
                xor r23, r23, r23
                slt r23, r1, r10        ; nacteny znak nesmi byt cislice
                bne r23, r0, end        ; konec pokud je

                addi r1, r1, 22         ; 'v' -> +22
                addi r2, r0, 122        ; r2 = ascii 'z'(122)
                xor r23, r23, r23
                slt r23, r2, r1         ; kontrola, jestli nepretecela abeceda (r1 musi byt < 'z')
                bne r23, r0, minus
next:       
                sb r1, cipher(r12)

                addi r12, r12, 1        ; inkrementujeme index loginu
                lb r1, login(r12)
                xor r23, r23, r23
                slt r23, r1, r10        ; nacteny znak nesmi byt cislice
                bne r23, r0, end        ; konec pokud je

                addi r1, r1, -9         ; 'i' -> -9
                addi r2, r0, 97         ; r2 = ascii 'a'(97)
                xor r23, r23, r23
                slt r23, r1, r2         ; kontrola, jestli nepretecela abeceda (r1 musi byt > 'a')
                bne r23, r0, plus       
loop:
                sb r1, cipher(r12)      ; ukladame nove pismeno
                addi r12, r12, 1        ; inkrementujeme index
                j main
plus:           
                addi r1, r1, 26         ; +26 ascii pokud pismeno je < 'a' 
                j loop
minus:
                addi r1, r1, -26        ; -26 ascii pokud pismeno je > z
                j next
end:            
                sb r0, cipher(r12)      ; '\0' na konec 

                daddi   r4, r0, cipher   ; vozrovy vypis: adresa login: do r4
                jal     print_string     ; vypis pomoci print_string - viz nize

                syscall 0   ; halt
print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address