# Lawrence Marquez
# Possible Final Project
# Palindrome Checker in MIPS

.data

startMessage: 
    .asciiz "Program is starting...\n"
file:
    .asciiz "/usr/share/dict/cracklib-small"
    .word 0

.text

main:

    li $v0, 13      # syscall to open a file
    la $a0, file    # load name into $a0 (first argument)


closeFile:
    li $v0, 16      # syscall to close a file
    