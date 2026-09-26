.section .bss
.lcomm str1, 256
.lcomm str2, 256
.lcomm convert, 32 


.section .data
msg1: .ascii "Enter string 1: "
len_msg1 = . - msg1

msg2: .ascii "Enter string 2: "
len_msg2 = . - msg2

hamming: .ascii "Hamming distance: "
hamming_length = . - hamming


.section .text
.global main
main:

# Write out "Enter string 1: "
mov $1, %rax 
mov $1, %rdi
mov $msg1, %rsi
mov $len_msg1, %rdx
syscall

# Get user input and store in msg1
mov $0, %rax
mov $0, %rdi
mov $str1, %rsi
mov $255, %rdx
syscall

# Write out "Enter string 2: "
mov $1, %rax 
mov $1, %rdi
mov $msg2, %rsi
mov $len_msg2, %rdx
syscall

# Get user input and store in msg2
mov $0, %rax
mov $0, %rdi
mov $str2, %rsi
mov $255, %rdx
syscall

# Write out "Hamming Distance "
mov $1, %rax 
mov $1, %rdi
mov $hamming, %rsi
mov $hamming_length, %rdx
syscall


xorq %r10, %r10     # clear %r10 register of garbage
movq $str1, %rsi    # Assign str1 pointer to %rsi
movq $str2, %rdi    # Assign str2 pointer to %rdi

Hamming:
   movb (%rsi), %al   # moves one leter (1 byte) from str1 to %al
   movb (%rdi), %bl   # moves one leter (1 byte) from str2 to %bl 

   cmpb $10, %al    # $10 check for the '\n' newline character 
   je LpreConvert  # if str1 is shorter, hamming stops
   cmpb $10, %bl    # if str2 is shorter, hamming stops 
   je LpreConvert

   xorb %bl, %al       # stores in %al
   movzbq %al , %rax   # takes 1 byte XOR result and extends zeros (to the left) to match 64 bit register
   popcntq %rax, %rcx  # counts the ones stored in %rax, 

   addq %rcx, %r10     # %r10 is the loop accumlator, adding the number of 1's per loop

   incq %rsi        # after XORing one char, increment the index so that it processes the next char in str1
   incq %rdi        # after XORing one char, increment the index so that it processes the next char in str2
   jmp Hamming     #restart until the shorter strings hit \n 

LpreConvert:
    mov $convert, %rcx   # moves convert buffer pointer into %rcx     
    movb $10, (%rcx)    # newline at the end of the buffer 

    mov %r10, %rax       # moves total hamming into %rax for division
    mov $10, %r11        # moves 10 into %r11 as the divisor 


Loopconvert:
    xorq %rdx, %rdx   # Takes hamming distance and converts to ascii
    divq %r11         
    addb $48, %dl     

    decq %rcx         
    movb %dl, (%rcx)  
    testq %rax, %rax
    jnz Loopconvert



out:
    mov $convert, %rdx
    addq $31, %rdx
    subq %rcx, %rdx

    mov $1, %rax     # outputs integer in ascii format
    mov $1, %rdi
    mov %rcx, %rsi

    syscall

mov $60, %rax
xorq %rdi, %rdi
syscall
