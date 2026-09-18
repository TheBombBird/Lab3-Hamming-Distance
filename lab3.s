.section .bss 
.lcomm ram, 256


.section .data
msg1: .ascii
.set len1, . - msg1



.section .text
.global _start
_start:




