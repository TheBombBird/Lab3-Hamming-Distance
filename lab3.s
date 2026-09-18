.section .bss 
.lcomm ram, 256


.section .data
msg1: .ascii



.section .text

_start:

mov $0,%rdi
mov %rdi,msg1



