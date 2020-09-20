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

errorMessage:      # error message for file not found
    .asciiz " ERROR - opening"

fileClosing:
    .asciiz "File Closing!\n"

buffer:         # buffer space for a character
    .space 4 

yo:
    .asciiz "yo im back\n"

exiting:
    .asciiz "exiting program\n"


.text

main:

    li $v0, 13      # syscall to open a file $a0 - filename, $a1 = flags, $a2 = mode
    la $a0, file    # load name into $a0 (first argument)
    li $a1, 0       # flags = 0
    li $a2, 0       # mode = 0 (read-only)
    syscall         # execute syscall
    jal closeFile   # jump and link close file

    li $v0, 4       # Testing String
    la $a0, yo      # 
    syscall         #

    j exit

errorFile:
    la $a0, errorFile
    li $v0, 4
    syscall

    j exit

closeFile:
    li $v0, 4
    la $a0, fileClosing
    syscall

    li $v0, 16      # syscall to close a file
    # empty out the file directory
    syscall         # execute the call

    jr $ra

exit:
    li $v0, 4  
    la $a0, exiting
    syscall

    li $v0, 10      # syscall to exit program
    syscall         # execute the call