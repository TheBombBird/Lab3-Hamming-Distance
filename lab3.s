.section .bss
.lcomm str1, 256
.lcomm str2, 256
.lcomm convert, 32


.section .data
msg1: .ascii "Enter string 1: "
len_msg1 = . - msg1

msg2: .ascii "Enter string 2: "
len_msg2 = . - msg2

hamming: .ascii "Hamming distance:\n"
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

xorq %r10, %r10 
movq $str1, %rsi
movq $str2, %rdi

.Hamming:
   movb (%rsi), %al
   movb (%rdi), %bl

   cmpb $10, %al
   je .LpreConvert
   cmpb $10, %bl
   je .LpreConvert

   xorb %bl, %al
   movzbq %al , %rax
   popcntq %rax, %rcx

   addq %rcx, %r10

   incq %rsi
   incq %rdi
   jmp .Hamming

.LpreConvert:
    mov $convert, %rcx
    addq $30, %rcx
    movb $10, (%rcx)

    mov %r10, %rax
    mov $10, %r11


.Loopconvert:
    xorq %rdx, %rdx
    divq %r11
    addb $48, %dl

    decq %rcx
    movb %dl, (%rcx) # saves char to %rdx
    testq %rax, %rax
    jnz .Loopconvert



.out:
    mov $convert, %rdx
    addq $31, %rdx
    subq %rcx, %rdx

    mov $1, %rax 
    mov $1, %rdi
    mov %rcx, %rsi

    syscall

mov $60, %rax
xorq %rdi, %rdi
syscall
