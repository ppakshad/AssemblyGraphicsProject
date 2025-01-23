stacksg segment stack  'stack'
    dw 32h dup(0)
    stacksg ends

datasg segment 'data'
        
    x0 dd 0  ;
    y0 dd 0  ;
    x1 dd 0  ;  SQU,REC
    y1 dd 0  ;
    se db 0  ;
    ;----------------------- 
    a  dd 0
    a0 dd 0
    b  dd 0   ;traindle
    b0 dd 0
    c  dd 0
    c0 dd 0 
    
    SQREDGE				DB		0
    CRCRADIUS			DB		0
    OVIDEO 	 			DB    	?
    NVIDEO    			DB    	12H
    TEMPROW				DW	70
    TEMPCOL				DW	400
    POINTX				DW	?
    POINTY				DW	?
    RADIUS				DW	?
    CURRENTROW			DB	?
    CURRENTCOL			DB	?
    INVRADIUS			DB	?	
   ;-------------- 
   msgrad db "Enter value of radus!",13,10,"$"
        str  db "************************************",13,10,
         db "* +.Menu Items:                    *",13,10,
         db "* +.Enter(s) to Draw a Square!     *",13,10,
         db "* +.Enter(r) to Draw a rectangle!  *",13,10,
         db "* +.Enter(c) to Draw a circle!     *",13,10,
         db "* +.Enter(q) to Exit!              *",13,10,
         db "************************************",13,10,
         db "Select one of them for Draw( ).",13,10,"$"
    datasg ends
codesg segment 'code'
      assume ss:stacksg,ds:datasg,cs:codesg
 ;+++++++++++++++++++++
      PUTC    MACRO   char
            PUSH    AX
            mov     AL, char
            mov     AH, 0Eh
            INT     10h     
            POP     AX
      ENDM
 ;++++++++++++++++++++++
  draw macro y1,y2,x1,color
        
               local l4
               mov cx,y1  ;col
               mov dx,x1  ;row
               
      l4:      mov ah,0ch
               
               mov al,color   ;pix color
               int 10h
               
               inc cx
               cmp cx,y2
               jne l4
    endm 
 ;+++++++++++++++++++++++++++++ 
  gotoxy macro x,y
	mov ah,2
 	mov dh,x	;row
	mov dl,y	;column

	push cx
	push bx
 	mov bh,0
 	int 10h
	pop bx
	pop cx
  endm
  ;++++++++++++++++++++
   cls macro near
         
         pusha
         mov cx,0
         mov dx,184fh
         mov bh,7
         mov ax,0600h
         int 10h
         popa

    cls endm
 ;++++++++++++++++++++++++++++++
     direct macro x1,x2,y1,color 
              
              local ll4
               
               mov cx,y1    ;col 
               mov dx,x1    ;row
               
      ll4:     mov ah,0ch               
               mov al,color   ;pix color
               int 10h
               
               inc x1 
               inc dx
                
               push cx
               mov cx,x1
               cmp cx,x2 
               pop cx
               jne ll4
              
    endm 
 ;+++++++++++++++++++++++++++++
  dline macro x1,x2,y1,color
                local lb
                mov cx,y1
                mov dx,x1
lb:             mov ah,0ch
                mov al,color
                int 10h
                dec cx
                inc dx
                cmp dx,x2
                jne lb
endm
;-----------------mmmmmmmmm
drline  macro x1,x2,y1,color
                local lbb
                mov cx,y1
                mov dx,x1
lbb:            mov ah,0ch
                mov al,color
                int 10h
                inc cx
                inc dx
                cmp dx,x2
                jne lbb
endm 
;++++++++++++++++++
select macro far
   local f 
    f:  
        gotoxy 7,28
        mov se,al
            
        mov ah,1
        int 21h
        cmp al,13
        jnz f
endm 
 ;++++++++++++++++
 txtmod macro
     
        mov al, 03h
	    mov ah, 0
	    int 10h
 endm 
 ;========================
  graphicmod macro
      mov al, 13h
      mov ah, 0       ; set graphics video mode. 
      int 10h
   endm 	
 ;--------------------    
  main proc 
    mov ax,datasg
    mov ds,ax 
    
    k:
       
        txtmod
        
         cls
         
        mov ah,9
        lea dx,str
        int 21h
     
       for: 
       
            select 
            
           
            
            cmp se,'r'
            jz rec
            cmp se,'s'     ;for draw rec,squ
            jz rec 
            
            cmp se,'c'
            jz cir
            
            cmp se,'q'
            jz exit
        
     jmp for

           
    rec:
        
         GOTOXY 9,0        
         call SCAN_NUM 
         mov x0,cx
         GOTOXY 10,0    
         call SCAN_NUM 
         mov y0,cx
         GOTOXY 11,0    
         call SCAN_NUM 
         mov x1,cx
          GOTOXY 12,0  
         call SCAN_NUM 
         mov y1,cx    
          
         graphicmod
         
         draw y0,y1,x0,07 ;--------------- 
         push x0
         direct x0,x1,y0,07
         pop x0
         direct x0,x1,y1,05      
         draw y0,y1,x1,09 ;--------------- 
         
         mov ah,7
         int 21h
    jmp k
    
    cir:
  
        
        call circle     
    jmp k
    
    exit:
    mov ax,4c00h
    int 21h
  endp
  ;---------------------------     
    Circle 			PROC  
        
				AND   	CX,0000H
				AND   	DX,0000H
				mov   	AH,0FH
				INT   	10H
				
				mov   	OVIDEO,AL

				mov   	AH,00H
				mov   	AL,NVIDEO
				INT   	10H
				gotoxy  2,2
				 
				gotoxy	4,10
getradius:			
                mov   	AH,01H
				INT   	21H
				cmp	AL,13
				JE	DRAWCRC
				mov	BL,AL
				SUB	BL,48
				mov	AL,CRCRADIUS
				mul	TEN
				mov	CRCRADIUS,AL
				add	CRCRADIUS,BL
				jmp	getradius
DRAWCRC:			
                mov	AL,CRCRADIUS
				mul	AL
				mov	RADIUS,AX
				mov	BL,CRCRADIUS
				mov	CURRENTROW,BL
				inc	CURRENTROW
CRCLR1:				DEC	CURRENTROW
				mov	CL,CRCRADIUS
				mov	CURRENTCOL,CL
				inc	CURRENTCOL
CRCLC1:				
                DEC	CURRENTCOL
				mov	AL,CURRENTROW
				mul	AL
				mov	POINTX,AX
				mov	AL,CURRENTCOL
				mul	AL
				mov	POINTY,AX
				mov	AX,POINTX
				add	AX,POINTY
				cmp	AX,RADIUS
				JA	COMPC1
				mov	TEMPROW,70
				mov	TEMPCOL,400
				mov	BH,0
				mov	CH,0
				mov	BL,CURRENTROW
				mov	CL,CURRENTCOL
				mov	DH,0
				mov	DL,CRCRADIUS
				add	TEMPROW,DX
				add	TEMPCOL,DX
				SUB	TEMPROW,BX
				add	TEMPCOL,CX	
				gotoxy	0,0
				mov	DX,TEMPROW
				mov	CX,TEMPCOL
				mov	AH,0CH
				mov	AL,5
				INT	10H
COMPC1:				cmp	CURRENTCOL,0
				JA	CRCLCL1
				cmp	CURRENTROW,0
				JA	CRCLRL1
				jmp	C2
CRCLRL1:				jmp 	FAR	PTR CRCLR1
CRCLCL1:				jmp 	FAR	PTR CRCLC1
C2:				mov	BL,CRCRADIUS
				mov	CURRENTROW,BL
				inc	CURRENTROW
CRCLR2:				
                DEC	CURRENTROW
				mov	CL,CRCRADIUS
				mov	CURRENTCOL,CL
				inc	CURRENTCOL
CRCLC2:				
                DEC	CURRENTCOL
				mov	AL,CURRENTROW
				mul	AL
				mov	POINTX,AX
				mov	AL,CURRENTCOL
				mul	AL
				mov	POINTY,AX
				mov	AX,POINTX
				add	AX,POINTY
				cmp	AX,RADIUS
				JA	COMPC2
				mov	TEMPROW,70
				mov	TEMPCOL,400
				mov	BH,0
				mov	CH,0
				mov	BL,CURRENTROW
				mov	CL,CURRENTCOL
				mov	DH,0
				mov	DL,CRCRADIUS
				add	TEMPROW,DX
				add	TEMPCOL,DX
				SUB	TEMPROW,BX
				SUB	TEMPCOL,CX	
				gotoxy	0,0
				mov	DX,TEMPROW
				mov	CX,TEMPCOL
				mov	AH,0CH
				mov	AL,5
				INT	10H
COMPC2:				
                cmp	CURRENTCOL,0
				JA	CRCLCL2
				cmp	CURRENTROW,0
				JA	CRCLRL2
				jmp	C3
CRCLRL2:				jmp 	FAR	PTR CRCLR2
CRCLCL2:				jmp 	FAR	PTR CRCLC2
C3:				mov	BL,CRCRADIUS
				mov	CURRENTROW,BL
				inc	CURRENTROW
CRCLR3:				DEC	CURRENTROW
				mov	CL,CRCRADIUS
				mov	CURRENTCOL,CL
				inc	CURRENTCOL
CRCLC3:				DEC	CURRENTCOL
				mov	AL,CURRENTROW
				mul	AL
				mov	POINTX,AX
				mov	AL,CURRENTCOL
				mul	AL
				mov	POINTY,AX
				mov	AX,POINTX
				add	AX,POINTY
				cmp	AX,RADIUS
				JA	COMPC3
				mov	TEMPROW,70
				mov	TEMPCOL,400
				mov	BH,0
				mov	CH,0
				mov	BL,CURRENTROW
				mov	CL,CURRENTCOL
				mov	DH,0
				mov	DL,CRCRADIUS
				add	TEMPROW,DX
				add	TEMPCOL,DX
				add	TEMPROW,BX
				SUB	TEMPCOL,CX	
				gotoxy	0,0
				mov	DX,TEMPROW
				mov	CX,TEMPCOL
				mov	AH,0CH
				mov	AL,5
				INT	10H
COMPC3:				cmp	CURRENTCOL,0
				JA	CRCLCL3
				cmp	CURRENTROW,0
				JA	CRCLRL3
				jmp	C4
CRCLRL3:	    jmp 	FAR	PTR CRCLR3
CRCLCL3:	    jmp 	FAR	PTR CRCLC3
C4:				mov	BL,CRCRADIUS
				mov	CURRENTROW,BL
				inc	CURRENTROW
CRCLR4:				DEC	CURRENTROW
				mov	CL,CRCRADIUS
				mov	CURRENTCOL,CL
				inc	CURRENTCOL
CRCLC4:				DEC	CURRENTCOL
				mov	AL,CURRENTROW
				mul	AL
				mov	POINTX,AX
				mov	AL,CURRENTCOL
				mul	AL
				mov	POINTY,AX
				mov	AX,POINTX
				add	AX,POINTY
				cmp	AX,RADIUS
				JA	COMPC4
				mov	TEMPROW,70
				mov	TEMPCOL,400
				mov	BH,0
				mov	CH,0
				mov	BL,CURRENTROW
				mov	CL,CURRENTCOL
				mov	DH,0
				mov	DL,CRCRADIUS
				add	TEMPROW,DX
				add	TEMPCOL,DX
				add	TEMPROW,BX
				add	TEMPCOL,CX	
				gotoxy	0,0
				mov	DX,TEMPROW
				mov	CX,TEMPCOL
				mov	AH,0CH
				mov	AL,5
				INT	10H
COMPC4:				cmp	CURRENTCOL,0
				JA	CRCLCL4
				cmp	CURRENTROW,0
				JA	CRCLRL4
				jmp	FAR	PTR	ENDC
CRCLRL4:				jmp 	FAR	PTR CRCLR4
CRCLCL4:				jmp 	FAR	PTR CRCLC4
ENDC:				mov	TEMPROW,70
				mov	TEMPCOL,400
				mov	CRCRADIUS,0
				gotoxy	11,2
 
				mov	AH,01H
				INT	21H
				RET		
Circle 			ENDP
  ;++++++++++++++++++++++++++++++++
  
 SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI        
        mov     CX, 0
        mov     CS:make_minus, 0
next_digit:
        mov     AH, 00h
        INT     16h
        mov     AH, 0Eh
        INT     10h
        cmp     AL, '-'
        JE      set_minus
        cmp     AL, 13  
        JNE     not_cr
        jmp     stop_input
not_cr:
        cmp     AL, 8                 
        JNE     backspace_checked
        mov     DX, 0             
        mov     AX, CX              
        DIV     CS:ten         
        mov     CX, AX
        PUTC    ' '                    
        PUTC    8                      
        jmp     next_digit
backspace_checked:
        cmp     AL, '0'
        JAE     ok_AE_0
        jmp     remove_not_digit
ok_AE_0:        
        cmp     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8    
        PUTC    ' '   
        PUTC    8             
        jmp     next_digit       
ok_digit:
        PUSH    AX
        mov     AX, CX
        mul     CS:ten                 
        mov     CX, AX
        POP     AX
        cmp     DX, 0
        JNE     too_big
        SUB     AL, 30h
        mov     AH, 0
        mov     DX, CX     
        add     CX, AX
        JC      too_big2    
        jmp     next_digit
set_minus:
        mov     CS:make_minus, 1
        jmp     next_digit
too_big2:
        mov     CX, DX     
        mov     DX, 0       
too_big:
        mov     AX, CX
        DIV     CS:ten  
        mov     CX, AX
        PUTC    8       
        PUTC    ' '    
        PUTC    8             
        jmp     next_digit        
stop_input:
        cmp     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:
        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       
ten             DW      10      
SCAN_NUM        ENDP
skip_proc_scan_num:
DEFINE_SCAN_NUM         ENDM
  ;++++++++++++++++++++
    codesg ends
end main