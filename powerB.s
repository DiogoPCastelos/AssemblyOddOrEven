.text

prompt: .asciz "---=== Welcome to Alex trying to learn assembly! ===---\n"
input_prompt: .asciz "Please (kindly) enter a number and I'll tell you whether it is even or odd!\n"
input: .asciz "%d"
output_odd: .asciz "Number %d is ODD!"
output_even: .asciz "Number %d is EVEN!"

.global main

main:

	# bullshit prologue (hate it)
	push %rbp          # push the base pointer
	mov %rsp, %rbp     # stack pointer value to base pointer
	
	# preparing to show prompt
	mov $0, %rax       # copying 0 to rax because printf should not take varargs
	mov $prompt, %rdi  # set the parameter in rdi (for printf)
	call printf        # calling function to print welcome prompt

	call read_and_check

	# CRAY CRAY EPILOGUE (the end people)
	mov %rbp,  %rsp    # clearing the stack
	pop %rbp           # restoring base pointer location

end:
	# exit code
	mov $0, %rdi       # setting the exit code (kinda like return 0 in c++)
	call exit

read_and_check:
	# again the stupid prologue
	push %rbp          # base pointer pushing for the new function
	mov %rsp, %rbp     # stack pointer value to base pointer
	
	mov $0, %rax       # again, printf will not take any varargs
	mov $input_prompt, %rdi # first parameter, the input prompt
	call printf        # calling the function
	
	sub $16, %rsp      # reserve space in the stack for input
			   # (in assembly memory is manually allocated)
	mov $0, %rax       # again, scanf will just take one argument
	mov $input, %rdi   # first parameter, the input
	lea -16(%rbp), %rsi# second parameter, the address of the reserved space
			   # (-16 because I moved it 16 bits up)
	call scanf

	mov -16(%rbp), %rsi# load the input value into RSI (second param register)
	
	mov %rsi, %rax     # copy input to rax
	mov $2, %rcx       # move value 2 to rcx (so we can divide later)
	mov $0, %rdx       # clear the contents of rdx
	div %rcx           # divide the content of rax by rcx
			   # (result SHOULD BE? stored in RAX and the % in RDX)
	cmp $0, %rdx       # compare rdx to 0
	jne odd            # JUMP NOT EQUAL to odd

even: 
	mov $0, %rax       # no varargs for prinft
	mov $output_even, %rdi # param 1 output string
	call printf
	ret
odd:
	mov $0, %rax       # no varargs for printf
	mov $output_odd, %rdi # param 1 output string
	call printf
	ret
