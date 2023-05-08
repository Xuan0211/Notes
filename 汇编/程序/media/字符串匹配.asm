datas  segment

        ;定义输入提示符 
        string1   db  'Enter keyword:$'
        string2   db  'Enter sentence:$'
        ;定义输出
        mess1   db  'Match at location:',?,?,' H of the sentence',13,10,'$'
        mess2   db    'No match.',13,10,'$'  

        nextline db  13,10,'$';回车 换行
        num db ?,13,10,'$'

        keyword     label   byte
                maxKeyLen     db      5
                KeyLen     db      ?           
                keyd   db      5 dup('$')    
        sentence     label   byte
                maxSenLen     db      10
                SenLen     db      ?           
                sente   db      10 dup('$')   
datas  ends

stacks segment 
    dw 0,0,0,0,0,0,0,0  
stacks ends


codes  segment 
        assume  cs:codes,ds:datas,es:datas
;-----------------------------------------
main    proc    far
        ;初始化栈
        mov ax,stacks
        mov ss,ax
        mov sp,16

        ;初始化代码段
        mov     ax,datas
        mov     ds,ax
        
        ;初始化拓展段
        mov     es,ax
start:	
;---------------------输入---------------------
        ;输入子串
     	    ;输出 提示符
            mov     ah,9H
            mov     dx,offset string1
            int     21H
            ;输入 keyword
            mov     dx,offset keyword 
            mov     ah,0ah  
            int     21h
            ;如果没有输入 直接退出
            cmp     KeyLen,0
            je      exit
            ;输出 换行
            mov     dx,offset nextline
            mov     ah,09
            int     21h
        ;输入主串
            ;输出 提示符
            mov     ah,9H
            mov     dx,offset string2
            int     21H
            ;输入 sentence
            mov     dx,offset sentence
            mov     ah,0ah  
            int     21h
            ;如果没有输入 直接退出
            cmp     SenLen,0
            je      exit
            ;输出 换行
            mov     dx,offset nextline 
            mov     ah,09
            int     21h     
;-------------------------------------------------- 
        mov     si,offset keyd
        mov     bx,offset sente
        mov     di,bx
        cld

        ;外循环循环SenLen - KeyLen + 1次
        mov     ch,0
        mov     cl,SenLen  
        sub     cl,KeyLen
        inc     cx 
 
;----------------------外循环----------------------
comp:
        push    cx
        push    di

        mov     cl,KeyLen ;关键字长度，一个字节
        mov     si,offset keyd
;----------------------内循环----------------------
        ;如果ds:si和es:di所指向的两个字节相等，则继续比较。
        ;repz cmpsb
        ;CMPSB指令，是用 DS:[SI] 所指的字节单元内容，减去 ES:[DI] 所指的字节单元的内容。
        repz    cmpsb  
        jz      find
;----------------------内循环----------------------

        pop     di
        pop     cx
        inc     di      
loop    comp
 ;----------------------外循环----------------------

Nfind:
        lea     dx,mess2 
        mov     ah,09
        int     21h
        jmp     exit 
 
find:   
        ;得到十进制的位置
        pop     di
        pop     cx
        sub     di,bx
        mov     bx,di
        inc     bx 
        ;变16进制
        mov     ax,bx
        mov     bh,16
        div     bh
        ;商在al中 并求ASCLL码 也就是16进制高位
        add     al,48
        ;余数在ah中 并求ASCLL码 也就是16进制低位
        add     ah,48
        ;合成输出语句
        mov     [mess1+18],al
        mov     [mess1+19],ah 
        ;输出
        mov    dx,offset mess1 
        mov     ah,09
        int     21h
        ;下一轮
        jmp     start 
exit:
        ;退出
        mov ah,4ch
        int 21h
main    endp

codes  ends            
        end     main 
 
 
 

