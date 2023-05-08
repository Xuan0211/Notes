datas   segment 

	result db        1,24 dup(0)
      pre  db        1,24 dup(0)
    mess0  db        0dh,0ah,'==================================','$'
    mess1  db        0dh,0ah,'Please choose a data from 1 to 100:','$'
    mess2  db        'The result is:','$'
    mess3  db        0dh,0ah,'Press Q/q to exit.','$'
 	mess4  db        0dh,0ah,'You have typed Q/q to exit.','$'
	mess5  db        0dh,0ah,'Input error,please re-enter.','$'
     flag  dw        ?

datas  ends

stacks segment
    dw 32 DUP(0)  
stacks ends

codes  segment
;----------------------------main-------------------------------
main       proc      far
assume    cs:codes,ds:datas,ss:stacks,es:datas
start:
 		;初始化栈
        mov     ax,stacks
        mov     ss,ax
        mov     sp,16

        ;初始化代码段
        mov     ax,datas
        mov     ds,ax
        
        ;初始化拓展段
        mov     es,ax
loopinput:
		;==================================
		mov       ah,09
		lea       dx,mess0
		int       21h
		;进栈 可以提高程序稳定性？
		push      ax          
		push      bx
		push      cx
		push      dx
		push      si
		push      di
		call      clear

		;Press Q/q to exit.
		mov       ah,09       
		lea       dx,mess3
		int       21h

		;Please choose a data from 1 to 100:
		lea       dx,mess1
		int       21h

		mov       bx,0
input:
		;输入
		mov       ah,01
		int       21h
		;是否退出
		cmp       al,'q' 
		jz        exit       
		cmp       al,'Q'
		jz        exit
		;是否是数字
		cmp       al,0dh
		jz        cont
		cmp       al,'0'      
		jb        error       
		cmp       al,':'
		jnb       error 
		;从ASCLL码变成数字
		sub       al,30h
		mov       ah,0
		; bx=bx+bx*10
		xchg      ax,bx
		mov       cx,10d		
		mul       cx; (DX, AX) ←  (AX) * (SRC)
		xchg      ax,bx
		add       bx,ax
jmp       input

error:  
		;Input error,please re-enter.
		mov       ah,09
		lea       dx,mess5
		int       21h

		pop       di          ;出栈
		pop       si
		pop       dx
		pop       cx
		pop       bx
		pop       ax
jmp       loopinput 

exit:  ;提示已退出程序信息
		mov       ah,09
		lea       dx,mess4
		int       21h
		mov       ah,4ch
		int       21h
		ret

cont:  
		cmp       bx,0
		jz        error
		mov       cx,bx    
		;if 如果小于等于2，直接输出1
		cmp       cx,2
		jle       call_f 
		;else 否则以cx-2作为外循环，把两个数相加
		sub       cx,2        
;--------------------Fibonacci计算循环---------------------
loopFi:  
		push      cx

		mov       cx,25
		mov       si,0
;--------------------大整数加法循环-----------------------
loopadd:  
		;从低位开始加
		mov       dl,pre[si]
		mov       dh,result[si]
		add       dl,dh       
		mov       result[si],dl
		mov       pre[si],dh    
		;如果有进位
		cmp       dl,10
		jae       carry 
		;else      
		inc       si
		jmp       ncarry
carry:  
		sub       result[si],10         
		inc       si
		add       pre[si],1     
ncarry:  
		loop      loopadd
;--------------------大整数加法循环-----------------------

		pop       cx
loop      loopFi
;--------------------Fibonacci计算循环---------------------

call_f:
		call      fibp
		pop       di          ;出栈
		pop       si
		pop       dx
		pop       cx
		pop       bx
		pop       ax
		jmp       loopinput     ;跳转回开始状态，进行下一次计算  

main      endp
;----------------------------main-------------------------------

fibp       proc      near
		;The result is
		lea       dx,mess2    ;输出显示提示
		mov       ah,09
		int       21h
;-----------------------从高位开始输出-------------------------
		mov       cx,25
		mov       si,24
printloop:  
		cmp       flag,0      ;标志位判断输出的高位是否为0
		jnz       print
		cmp       result[si],0
		jz        continue
		add       flag,1
print:  
		mov       dl,result[si];以十进制输出
		add       dl,48
		mov       ah,02h
		int       21h
continue:  
		dec       si
loop      printloop
;-----------------------从高位开始输出-------------------------
		ret
fibp   endp

;---------------------清空临时使用的数组----------------------
clear       proc      near

		mov       flag,0
		mov       result[0],1d
		mov       pre[0],1d
		mov       si,1

		mov       cx,24
clearloop:  
		mov       result[si],0
		mov       pre[si],0
		add       si,1
loop      clearloop

		mov       si,0

		ret

clear   endp
;---------------------清空临时使用的数组----------------------

codes  ends 
        end     main     
