.code16
    cli
    ljmp $0, $1f
1:
    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %bp
    mov %ax, %ss
    mov %bp, %sp

.equ CODE_SEG, 8
.equ DATA_SEG, gdt_data - gdt_start
lgdt gdt_descriptor

    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0
    ljmp $CODE_SEG, $protected_mode

gdt_start:
gdt_null:
    .long 0x0
    .long 0x0
gdt_code:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x0
gdt_data:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0
gdt_end:
gdt_descriptor:
    .word gdt_end - gdt_start
    .long gdt_start

.code32
protected_mode:
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    mov $0X7000, %ebp
    mov %ebp, %esp
    sgdt 0x7000
    
vga_print:
    mov $message, %ecx
    mov $16, %eax
    mov $0, %edx
    mov $17, %ebx
    div %ebx
    mov %edx, %eax
    mov $80, %edx
    mul %edx
    lea 0xb8000(%eax), %edx
    mov $0x0F, %ah
loop:
    mov (%ecx), %al
    cmp $0, %al
    jz end
    mov %ax, (%edx)
    add $1, %ecx
    add $2, %edx
    jmp loop
end:
    jmp .
message:
    .asciz "hello world" 