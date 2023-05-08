datas segment
  mess1 db 'Input name:','$'
  mess2 db 'Input a telephone number:','$'
  mess3 db 'Do you want a telephone number?(Y/N)','$'
  mess4 db 'name?',10,13,'$' 
  mess5 db 'name',19 dup(0),'tel.',10,13,'$'
  mess6 db 'Not find!',10,13,'$'
  findline db  13,10,'$';回车 换行
  
  ;输入的姓名
  namein label byte
    maxNLen db 20
    NLen db ?
    nam db 20 dup('$')
  ;输入的电话号码
  phonein label byte
    maxPLen db 10
    PLen db ?
    phone db 10 dup('$')

  ;待查询的姓名
  temp_nam db 20 dup(?)

  ;临时一条电话簿
  temp_tab db 20 dup(?),4 dup(?),10 dup(?),13,10,'$'

  ;电话簿中已有的数据量
  num dw 0
  ;电话簿
  tel_tab db 50 dup(20 dup(?),4 dup(?),10 dup(?),13,10,'$')

datas ends

stacks segment
    dw 0,0,0,0,0,0,0,0  
stacks ends

codes segment
;----------------------------main-------------------------------
main proc far
    assume cs:codes,ds:datas,es:datas     
start:
  ;初始化栈
  mov ax,stacks
  mov ss,ax
  mov sp,16

  ;初始化代码段
  mov ax,datas
  mov ds,ax
        
  ;初始化拓展段
  mov es,ax
;---------------------输入---------------------
input:
  ;输入名字
    ;输出 提示符
    lea dx,mess1
    mov ah,09h
    int 21h

    ;清空各个临时变量
    call clear

    ;输入名字
    call input_name

    ;如果没有输入就退出
    cmp NLen,0
    je query

    ;储存名字
    call store_name

  ;输入电话号码
    ;输出 提示符
    lea dx,mess2
    mov ah,09h
    int 21h
    ;输入 电话号码
    call input_phone
    call name_sort

    jmp input
;---------------------输入---------------------
;---------------------查询---------------------
query:

  ;是否继续查询
    ;输出 提示是否进行查询
    mov ah,09
    lea dx,mess3
    int 21h

    ;输入 Y/N
    mov ah,01h
    int 21h

    ;if N
    cmp al,'N'
      je exit

  ;换行
    mov dx,offset findline 
    mov  ah,09
    int 21h 

  ;输入 名字
    ;输出 提示符
    mov ah,09
    lea dx,mess4
    int 21h
    ;输入 名字
      call input_name
    ;if 没有输入 -> 退出
    cmp NLen,0
    je exit
  ;查询
    call name_query
  ;输出
    call printline

    jmp query
;---------------------查询---------------------
exit:
    mov ah,4ch
    int 21h
main endp
;----------------------------main-------------------------------


input_name proc near
;输入名字 -> namein
    lea dx,namein
    mov ah,10
    int 21h

    mov dx,offset findline 
    mov  ah,09
    int 21h

    ret
input_name endp


store_name proc near
;copy name to temp_tab
  ;if Nlen==0 -> exit
    cmp NLen,0
    je exit1

  ;原串
    lea si,nam
  ;目标串
    lea di,temp_tab
  ;cx
    sub ch,ch
    mov cl,NLen
  ;清空
    cld

  ;自动复制字符串
    rep movsb
  
exit1:
    ret
store_name endp



input_phone proc near
;输入phone 并且 和 name合并到临时串中
  ;输入
    lea dx,phonein
    mov ah,10
    int 21h

    cmp PLen,0
    je exit2

  ;换行
    mov dx,offset findline 
    mov  ah,09
    int 21h  

  ;原串 
    lea si,phone
  ;目标串
    lea di,temp_tab
    add di,23;和 name合并
  ;cx
    sub ch,ch
    mov cl,PLen
  ;清空
    cld

  ;自动复制字符串
    rep movsb
exit2:
    ret
input_phone endp

name_sort proc near
;插入排序
  ;if(num==0)
    cmp num,0
    ;查询插入位置，并插入
    ;插入排序
      jnz sort
  ;else
    ;直接插入
    lea si,temp_tab
    lea di,tel_tab
    mov cx,37;要传送的数据段长度
    cld
    repz movsb
    jmp exit3

sort:

  ;待插入的串
    lea si,temp_tab
  ;当前比较项（从头开始）
    lea di,tel_tab

    mov cx,num
comp:
    push di
    push cx

	;比较姓名
    mov cx,20
;---------------------内循环-------------------------
    repz cmpsb
  	;如果si>di,则使di指向下一个表项，继续循环
    ja find_tab
;---------------------内循环--------------------------

	;出口：如果比到了最后，说明这一条<=待插入项
    pop cx
    pop di
    call insert
    jmp exit3

find_tab:
    pop cx
    pop di

    add di,37
    lea si,temp_tab

loop comp

	;如果比到了最后，在最后插入
    mov cx,37
    rep movsb

exit3:
    ;num++
    inc num
    ret
name_sort endp


insert proc near
;找到位置后，插入
	;从当前表的最后一项开始一格一格往后挪
    mov ax,num
	;cx的初值由上一个程序带进来

;要把后面的数据都往后挪一格 也就是cx个
loopinsert:

    push ax
	;计算待往后一格的数组的位置
		;计算偏移量
			mov bx,37
			;ax=bx(37)*ax(num)
			mul bx
		;数组位置
    	lea di,tel_tab
		;相加
    	add di,ax
	;计算后一格的位置
		mov si,di
		sub si,37
	;复制字符串
		push cx

		mov cx,37
		rep movsb

		pop cx
    pop ax
    dec ax
    loop loopinsert
	;插入
		;源串地址
		lea si,temp_tab
		;目标串地址
		lea di,tel_tab
		mov bx,37
		mul bx
		add di,ax
		;次数
		mov cx,37
		;复制
		rep movsb
    ret
insert endp

name_query proc near
;查询
    call clear
    mov ch,0
    mov cl,NLen
    lea si,nam
    lea di,temp_nam;name-->temp_nam
    rep movsb
    mov cx,num;搜寻名字循环次数
    lea di,tel_tab
    lea si,temp_nam
loopfind:

    push di
    push cx
    mov ch,0
    mov cl,20

	;比较字符串
    repz cmpsb
	;出口 找到了 num-cx
    je found

    pop cx
    pop di
	;继续找
    add di,37
    lea si,temp_nam
    loop loopfind

    mov cx,0;没找到
    jmp exit4
found:
    pop cx
    pop di
exit4:
    ret
name_query endp
;-------------------------------------------------------------------
printline proc near
;输出
	;if(找到）
    cmp cx,0
    	jnz find
    ;else(未找到）
    mov ah,09
    lea dx,mess6
    int 21h

    jmp exit5
find:
    lea dx,mess5
    mov ah,09
    int 21h
	;dx=tel_tab+(num-cx)*37
    mov ax,num
    sub ax,cx
    mov bx,37
    mul bx;
    lea dx,tel_tab
    add dx,ax
    mov ah,09
    int 21h
exit5:
    ret
printline endp

clear proc near
;清空
    lea di,temp_tab
    xor al,al
    mov cx,32
    rep stosb
    lea di,temp_nam
    xor al,al
    mov cx,20
    rep stosb
    ret
clear endp

codes ends
    end start