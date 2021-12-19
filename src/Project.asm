include irvine32.inc
includelib irvine32.lib

.data
myArray dword 20 dup(?)
arraySize dword 0
numberOfPush dword 0

;Following UI instructions
msgm_1 byte "0 Create an array || 1 Move array to stack || 2 Move stack to array || 3 Reverse array || -1 exit",0ah,0
msgm_2 byte "What do you want to do now?",0ah,0
msgm_3 byte "Invalid entry, please try again!",0ah,0
msg0_1 byte "What is the size N of array? (Can be 1 to 20)",0ah,0
msg0_2 byte "What is(are) the ",0
msg0_3 byte " value(s) in array?",0ah,0
msg0_4 byte "Invalid size! Please try again!",0ah,0
msg0_5 byte "Reading number ",0
msg0_51 byte ":",0ah,0
msg0_6 byte "Succeed creating array! You have created:",0ah,0
msg1_1 byte "Array is empty, nothing to push!",0ah,0
msg1_2 byte "You have moved the following array into stack:",0ah,0
msg2_1 byte "Stack empty!",0ah,0
msg2_2 byte "Array poped out is:",0ah,0
msg3_2 byte "Array poped out(reversed) is:",0ah,0

.code
main proc
mainMenu:
	mov edx,OFFSET msgm_1
	call WriteString
	mov edx,OFFSET msgm_2
	call WriteString
	call ReadInt
	jo invalidMainInput
	cmp eax,0
	jz option0
	cmp eax,1
	jz option1
	cmp eax,2
	jz option2
	cmp eax,3
	jz option3
	cmp eax,-1
	jz optionm1

	jmp invalidMainInput

invalidMainInput:
	mov edx,OFFSET msgm_3
	call WriteString
	jmp mainMenu

option0:
	mov edx,OFFSET msg0_1
	call writestring
	call ReadInt
	jo option0_invalidsize
	cmp eax,20
	jg option0_invalidsize
	cmp eax,1
	jl option0_invalidsize

succeed:
	mov arraySize,eax
	mov ecx,eax
	mov eax,1
	mov esi,0
l4:	mov edx,OFFSET msg0_5;"Reading number X"
	call WriteString
	call writeDec;X
	mov edx,OFFSET msg0_51;the colon
	call WriteString
	push eax;eax is using for counting the numbers
i1:	call ReadInt
	jo i1
	mov myArray[4*esi],eax
	pop eax
	inc eax
	inc esi
	loop l4
	mov edx,OFFSET msg0_6;"Succeed creating array! You have created:"
	call writestring
	call WriteArray
	jmp mainmenu

option0_invalidsize:
	mov edx,OFFSET msg0_4
	call writestring
	jmp option0

option1:;move array to stack
	cmp arraySize,0
	jz op1error
	call ArrayToStack
	inc numberOfPush
	mov edx,OFFSET msg1_2;"You have moved the following array into stack:",0ah,0
	call writestring
	call WriteArray
	jmp mainmenu
op1error:
	mov edx,OFFSET msg1_1;empty array
	call writeString
	jmp mainmenu

option2:
	cmp NumberOfPush,0
	jz op2error
	call StackToArray
	dec numberOfPush
	mov edx,OFFSET msg2_2;"Array poped out is:"
	call WriteString
	call WriteArray
	jmp mainmenu
op2error:
	mov edx,OFFSET msg2_1;"Stack empty!"
	call writeString
	jmp mainmenu

option3:
	cmp NumberOfPush,0
	jz op3error
	call StackReverse
	dec numberOfPush
	mov edx,OFFSET msg3_2;"Array poped out(reversed) is:"
	call WriteString
	call WriteArray
	jmp mainmenu
op3error:
	mov edx,OFFSET msg2_1;"Stack empty!"
	call writeString
	jmp mainmenu

optionm1:
	invoke ExitProcess,0
main endp

ArrayToStack proc
;The total sequence of pushing is [all element is array],arraySize. Empty entries are not pushed.
	pop edx;Immediately after calling, the top of stack is the return address. We need to clear the stack and save it. Pushed back at p1
	mov ecx,arraySize
	mov esi,0
l1:	mov eax,myArray[esi*type myArray]
	push eax
	inc esi
	loop l1
	push arraySize
p1:	push edx
	ret
ArrayToStack endp

StackToArray proc
	pop edx;push back at p2
	pop ecx;arraySize
	mov arraySize,ecx
	mov esi,ecx
	dec esi;note indexing is 1 smaller than size
l2:	pop myArray[esi*type myArray]
	dec esi
	loop l2
p2:	push edx
	ret
StackToArray endp

StackReverse proc
	pop edx;push back at p3
	pop ecx;arraySize
	mov arraySize,ecx
	mov esi,0
l3:	pop myArray[esi*type myArray]
	inc esi
	loop l3
p3:	push edx
	ret
StackReverse endp

WriteArray proc
	mov esi,0
	mov ecx,arraySize
l5:	mov eax, myArray[esi*type myArray]
	call writeInt
	mov eax, 20h
	call WriteChar
	inc esi
	loop l5
	mov eax,0ah
	call WriteChar
	ret
WriteArray endp

END main
