# Lawrence Marquez
# Possible Final Project
# Palindrome Checker in MIPS

# TODO: Add printf.s to allow me to print formatted strings.
# Work on the Opening of the File Provided and implement error handling.
# Learn how to make a character array to hold dictionary
# Learn how to loop through the dictionary.

.data

startMessage:   # starting message for the program
    .asciiz "Program is starting...\n" 
    .word 0
file:           # path location for the file to be used.
    .asciiz "/usr/share/dict/cracklib-small"
    .word 0

errorFile:      # error message for file not found
    .asciiz " ERROR - opening %s\n"
buffer:         # buffer space for a character
    .space 4 


.text

main:

    li $v0, 13      # syscall to open a file
    la $a0, file    # load name into $a0 (first argument)

errorFile:
    la $a0, errorFile
    jal printf


closeFile:
    li $v0, 16      # syscall to close a file

    