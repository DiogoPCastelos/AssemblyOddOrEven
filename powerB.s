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
	movq $0, %rdi       # setting the exit code (kinda like return 0 in c++)
	call exit

read_and_check:
	# again the stupid prologue
	pushq %rbp          # base pointer pushing for the new function
	movq %rsp, %rbp     # stack pointer value to base pointer
	
	movq $0, %rax       # again, printf will not take any varargs
	movq $input_prompt, %rdi # first parameter, the input prompt
	call printf         # calling the function
	
	subq $16, %rsp      # reserve space in the stack for input
			    # (in assembly memory is manually allocated)
	movq $0, %rax       # again, scanf will just take one argument
	movq $input, %rdi   # first parameter, the input
	leaq -16(%rbp), %rsi# second parameter, the address of the reserved space
			    # (-16 because I moved it 16 bits up)
	call scanf          #actual printing

	movq -16(%rbp), %rsi# load the input value into RSI (second param register)
	
	movq %rsi, %rax     # copy input to rax
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
	
	jmp clear_stack     # jumping to clear_stack label
odd:
	movq $0, %rax       # no varargs for printf
	movq $output_odd, %rdi # param 1 output string
	call printf         # actual function calling
	
	jmp clear_stack     # jumping to clear_stack label
clear_stack:
	movq %rbp, %rsp     # copy rbp to rsp
	popq %rbp           # popping rbp (clearing stack)
	
	ret                 # returning
