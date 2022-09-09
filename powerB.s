.data
number: .quad 0 #number variable to save input

.text

prompt: .asciz "---=== Welcome to Alex trying to learn assembly! ===---\n"
input_prompt: .asciz "Please (kindly) enter a number and I'll tell you whether it is even or odd!\n"
input: .asciz "%ld"
output_odd: .asciz "Number %ld is ODD!\n"
output_even: .asciz "Number %ld is EVEN!\n"

.global main

main:

	# bullshit prologue (hate it)
	push %rbp          # push the base pointer
	mov %rsp, %rbp     # stack pointer value to base pointer
	
	# preparing to show prompt
	movq $0, %rax       # copying 0 to rax because printf should not take varargs
	movq $prompt, %rdi  # set the parameter in rdi (for printf)
	call printf         # calling function to print welcome prompt

	call read_and_check

	# CRAY CRAY EPILOGUE (the end people)
	movq %rbp,  %rsp    # clearing the stack
	popq %rbp           # restoring base pointer location

end:
	# exit code
	call exit

    #epilogue
   	movq %rbp, %rsp     # copy rbp to rsp
	popq %rbp           # popping rbp (clearing stack)

read_and_check:
	# again the stupid prologue
	pushq %rbp          # base pointer pushing for the new function
	movq %rsp, %rbp     # stack pointer value to base pointer
	
	movq $0, %rax       # again, printf will not take any varargs
	movq $input_prompt, %rdi # first parameter, the input prompt
	call printf         # calling the function
	
    #"prints" out input
    mov $input, %rdi #sets first parameter to input string
    mov $number, %rsi #sets the address of the variable "number" in register rsi
    mov $0, %rax #o rax
    call scanf #call scanf to scan for input
	
	movq number, %rax     # copy input to rax
	movq $2, %rcx       # move value 2 to rcx (so we can divide later)
	movq $0, %rdx       # clear the contents of rdx
	divq %rcx           # divide the content of rax by rcx
			    # (result SHOULD BE? stored in RAX and the % in RDX)
	cmpq $0, %rdx       # compare rdx to 0
	jne odd             # JUMP NOT EQUAL to odd

even: 
	movq $0, %rax       # preparing the print function
	movq $output_even, %rdi # first argument
	call printf         # calling function 
	
	jmp end     # jumping to end label
odd:
	movq $0, %rax       # no varargs for printf
	movq $output_odd, %rdi # param 1 output string
	call printf         # actual function calling
	
	jmp end     # jumping to end label
