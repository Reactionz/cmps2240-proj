# Lawrence Marquez
# CMPS 2240 - Assembly Language
# Code we work on in class for the semester project.
# date started: October 1, 2020
# written by: Gordon Griesel, modified by Lawrence Marquez

.data
string1:    .asciiz "\n2240 Semester Project\n\n"
filename:   .asciiz "/usr/share/dict/cracklib-small"

# dynamically allocate memory for this buffer
# buff:       .byte 0:512000

.text
.globl main

main:
    li $v0, 4           # code 4 is to print a string
    la $a0, string1     # load address of string
    syscall             # execute syscall

    li $v0, 13          # open a file
    la $a0, filename    # load the filename
    li $a1, 0           # open for reading
    syscall             # 
    move $s0, $v0       # file descriptor returned in $v0 into $s0

                        # allocate memory for a buffer
    li $v0, 9           # syscall 9
    li $a0, 512000      # how much memory, in bytes
    syscall             # syscall 
    move $s3, $v0       # $s3 holds address of a buffer.
                        # the address of the start of the dictionary
                        
                        # read the file
    li $v0, 14          # service #14
    move $a0, $s0       # load file descriptor
    # la $a1, buff        # buffer to store data read
    move $a1, $s3       
    li $a2, 512000        # how many characters to read?
    syscall 

                        # see if this actually works
    li $v0, 4           # service 4 print string 
    # la $a0, buff
    move $a0, $s3
    syscall
    jal newline

                        # setup data pointers
    # la $s1, buff        # like the C program *d pointer
    # la $s2, buff        # similar to C *p pointer
    #                     # C: t1 = *p
    move $s1, $s3        # like the C program *d pointer
    move $s2, $s3        # similar to C *p pointer
topLoop:
    lb $t0, ($s2)       # dereferencing $s2 (no offset)
    beqz $t0, finished  # null means end of the file, done.
    li $t1, 10          # store a new line character

nltest:
    lb $t0, ($s2)               # get the character at address $s2
    beq $t0, $t1, end_of_a_word # test a character
    addiu $s2, $s2, 1           # not a new line
    j nltest                    # go test again

end_of_a_word:
    sb $0, ($s2)        # null terminator at end of a word

# do the check for the palindrome and decide if you even print it

                        # see if this actually works
    li $v0, 4           # service 4 print string 
    move $a0, $s1       #
    syscall             # see an individual word (string)
    jal newline
    jal newline
    addiu $s2, $s2, 1   # increment
    move $s1, $s2
    j topLoop
    

finished:
    li $v0, 16          # close the file
    move $a0, $s0       # load the file descriptor
    syscall             # 

    li $v0, 10          # exit gracefully
    la $a0, 0           #
    syscall             #


# radar
# r   r
#  a a
#   d
                        # subroutine - check for palindrome
                        # must have a stack frame
                        # return 1 for a palindrome, else return 0
isPalindrome:


newline:                # new line function
    li $v0, 11          # 11 = show character
    li $a0, 10          # ascii newline
    syscall             #
    jr $ra              # return to $ra address