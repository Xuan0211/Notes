datas   segment

  string1   db  13,10,'Please enter the string:','$'
  mess1   db  13,10, 'The total number of letter : ','$'
  mess2   db  13,10,'The total number of digit  : ','$'
  mess3   db  13,10,'The total number of other character : ','$'

  letterLen   db   ?
  digitLen    db   ?
  otherLen    db   ?
  string   label  byte
    maxLen db 80 
    Len  db ?  
    str db 80 dup('$')

datas   ends

stacks segment
    dw 0,0,0,0,0,0,0,0  
stacks ends

codes  segment
      assume  cs:codes,ds:datas
start: 
;--------------------初始化-----------------------
        ;初始化栈
      mov ax,stacks
        mov ss,ax
        mov sp,16

        ;初始化代码段
        mov     ax,datas
        mov     ds,ax
        
        ;初始化拓展段
        mov     es,ax

    ;初始化变量
    mov   letterLen,0
    mov   digitLen,0
    mov   otherLen,0
;--------------------初始化-----------------------

;---------------------输入---------------------
    ;输出 提示符
    mov   dx,offset string1
    mov   ah,09h  
    int   21h
    ;输入字符串
    lea   dx,string
    mov   ah,0ah
    int   21h
;---------------------输入---------------------
    sub   ch,ch
    mov   bx,offset len
    mov   cx,[bx]
    mov   si,offset str
;------------------手搓循环---------------------
loop1:
       	mov   al,[si]
IsDigit: 
		cmp   al,'0'
		jb    IsOther  
		cmp   al,'9'
		ja    IsBig    
		inc   digitLen
		jmp   continue
IsBig: 
    ;不是数字也不是字母--是其他
		cmp   al,'A'       
		jb    IsOther   
		cmp   al,'Z'
		ja    IsSmall 
		inc   letterLen
		jmp   continue  
IsSmall:  
		cmp   al,'a'
		jb    IsOther
		cmp   al,'z'
		ja    IsOther
		inc   letterLen
		jmp   continue
IsOther: 
       	inc   otherLen
     
continue:  
		inc   si
		dec   cl
		cmp   cl,0
		jz    print 
		jmp   loop1   
;------------------手搓循环---------------------
;--------------------输出-----------------------
print:   
		mov   dx,offset mess1
		mov   ah,09h
		int   21h
		mov   al,letterLen
		call  PinD

		mov   dx,offset mess2
		mov   ah,09h
		int   21h
		mov   al,digitLen
		call  PinD

		mov   dx,offset mess3
		mov   ah,09h
		int   21h
		mov   al,otherLen
		call  PinD
;--------------------输出-----------------------
exit:
		mov   ah, 4ch
		int  21h
;---------------子程序：转10进制输出---------------
PinD:  
	
		mov  ah, 0
		mov  bl, 10
		div  bl
		;输出高位        
		add  al, 48    

		mov  dl, al ;ax要拿来输出，先暂存下     
		mov  bh, ah ;ax要拿来输出，先暂存下 

		mov  ah, 02h     
		int  21h 
		;输出低位
		mov  al, bh        
		add  al, 48
		mov  dl, al    						
		mov  ah, 02h
		int  21h 

		ret
;---------------------------------------  
codes   ends
end   start
