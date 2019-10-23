; PROGRAM NAME: BLOCK TRANSFER WITHOUT USING STRING INSTRUCTION


%macro cmn 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	
      array db 0AAH,0BBH,0CCH,0DDH,0EEH,0FFH,0ABH,0CDH,0EFH,0FFH
        m1 db 10,"Enter elements(10) : "
        m1len equ $-m1
       
        space db " "
        spacelen equ $-space
         
        num db 00h
        cntr db 00h
        
        menu db 10,"1.Non-overlapping"
             db 10,"2.Overlapping"
             db 10,"3.Exit "
             db 10,"Enter your choice : "
        menulen equ $-menu
        
        menu2 DB 10,"1.POSITIVE DISPLACEMENT "
              DB 10,"2.NEGATIVE DISPLACEMENT "
              DB 10,"eNTER YOUR CHOICE : "
        menu2len equ $-menu2
        
        m5 db 10,"Destination block before data transfer : "
        m5len equ $-m5
        
        m6 db 10,"Destination block after data transfer : "
        m6len equ $-m6
        
	  ms db 10,"dESTINATION BEFORE TRANSFER :"
        mslen equ $-ms

        m7 db 10,"source block : "
        m7len equ $-m7

section .bss
	array2 resb 100
	temp resb 3
	choice resb 2
	dispbuff resb 2
	
section .text
global _start
_start:
	
	
        

QW:	cmn 1,1,menu,menulen      ;DISPLAY MENU 
	cmn 0,0,choice,2
	mov al,[choice]
	cmp al,31h
	je s1
	cmp al,32h
	je s2
	jmp ext


s1:     call novr		
        jmp ext

s2:     cmn 1,1,menu2,menu2len
       cmn 0,0,choice,2
	mov al,[choice]

        cmp al,31h
        je sa1
        cmp al,32h
        je sa2
        jmp ext

sa1:    call povr
        jmp ext

sa2:    call ngovr
        JMP ext

ext:    mov rax,60
		mov rdi,0
		syscall
	

prnt :          ;PROCEDURE TO PRINT 1 BYTE(2 DIGIT NO.)
		xor rax,rax
		mov al,[num]
		mov rdi,dispbuff+1
            mov cl,02h
          
          p2: 
          	xor rdx,rdx
            xor rbx,rbx
            mov bl,10h
            div ebx
            cmp dl,09h
            jbe p1
            add dl,07h
          
            p1:
            	add dl,30h
            	mov [rdi],dl
            	dec rdi
            	dec cl
            	jnz p2
		cmn 1,1,dispbuff,2
		cmn 1,1,space,spacelen
ret
	

bprnt : 			;PROCEDURE TO PRINT BLOCK POINTED BY rsi      
                        ;IT ASSUMES "cntr" VARIABLE AS COUNTER
                        ;SO NUMBER OF ELEMENTS TO PRINT(COUNTER) MUST BE GIVEN IN "cntr" VARIABLE
cnts2:  
		
	mov bl,[rsi]
      mov [num],bl
      push rsi
	call prnt
	pop rsi
      inc rsi
      dec byte[cntr]
      jnz cnts2
ret
        
novr :      			;NONOVERLAPPING BLOCK TRANSFER
     mov rdi,array2
     mov byte[cntr],0ah

     x1:     
     			mov al,00h    ;INITIALISING DESINATION BLOCK WITH ALL 00 ELEMENTS
	            mov [rdi],al
			INC rdi
	            dec byte[cntr]
      	      jnz x1

               cmn 1,1,m5,m5len
                mov rsi,array2    ;PRINTING THE DESTINATION BLOCK
        mov byte[cntr],0Ah
        call bprnt

        mov rsi,array         ;TRANSFERING DATA FROM array TO array2
        mov rdi,array2
        mov byte[cntr],0Ah
        x2: mov al,[rsi]
                mov [rdi],al
                inc rsi
                inc rdi
                dec byte[cntr]
                jnz x2

              cmn 1,1,m7,m7len
        mov rsi,array            ;PRINTING THE SOURCE BLOCK AFTER DATA TRANSFER
        mov byte[cntr],0Ah
        call bprnt


              cmn 1,1,m6,m6len
                mov rsi,array2    ;PRINTING DESTINATION BLOCK AFTER DATA TRANSFER
        mov byte[cntr],0Ah
        call bprnt
ret
        
povr :  			;PROCEDURE FOR OVERLAPPING POSITIVE DISPLACEMENT

        
        mov rsi,array   ;TRANSFERING THE DATA
        mov rdi,array+5
        mov byte[cntr],0Ah
        Ax2: mov al,[rsi]
                mov [rdi],al
                inc rsi
                inc rdi
                dec byte[cntr]
                jnz Ax2

               cmn 1,1,m6,m6len
                mov rsi,array   ;PRINTING THE DATA FROM array ONWARDS
        mov byte[cntr],0Fh
        call bprnt
ret    
        
ngovr :


        mov rsi,array    ;DATA TRANSFER 
        mov rdi,array-5
        
        mov byte[cntr],0Ah
        Axv2: mov al,[rsi]
                mov [rdi],al
                INc rsi
                INC rdi
                dec byte[cntr]
                jnz Axv2

               cmn 1,1,m6,m6len
                mov rsi,array-5           ;PRINTING DATA FROM array ONWARDS
        mov byte[cntr],0Fh
        call bprnt
ret
    


        


