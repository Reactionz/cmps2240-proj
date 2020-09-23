# Lawrence Marquez
# Possible Final Project
# Palindrome Checker in MIPS

# Original C Version of the Code
                  
# include <stdio.h>
# include <stdlib.h>
# const char filename[] = "/usr/share/dict/cracklib-small";

# int main() { 
#	printf("Program is starting...\n");
#	FILE *fpi;
#	fpi = fopen(filename, "r");
#	if (!fpi) {
#		printf("ERROR - opening %s\n", filename);
#		exit(0);
#	}
#	char *dict = (char *)malloc(512000 * sizeof(char));
#	int ret = fread(dict , 1, 512000, fpi);
#	fclose(fpi);
#	dict[ret] = '\0';
#	//printf("%s", dict);
#	char *d = dict;
#	char *p = d;
#	while (*p != '\0') {
#		while (*p != '\n') {
#			++p;
#		}
#		*p = '\0';
#		//if (isPalindrome(d))
#		printf("word: **%s**\n", d);
#		++p;
#		d = p;
#	}
#	free(dict);
#	return 0;
# }

# TODO: Add printf.s to allow me to print formatted strings. *DONE*
# Work on the Opening of the File Provided and implement error handling. *DONE*
# Learn how to make a character array to hold dictionary
# Learn how to loop through the dictionary.

.data

startMsg:   # starting message for the program
    .asciiz "Program is starting...\n" 
    .word 0
file:           # path location for the file to be used.
    .asciiz "/usr/share/dict/craclib-small"
    .word 0

errMsg:      # error message for file not found
    .asciiz " ERROR - opening %s\n"

closing:
    .asciiz "File Closing!\n"

buffer:         # buffer space for a character
    .space 4 

yo:
    .asciiz "yo im back\n"

exiting:
    .asciiz "exiting program\n"


.text

main:
    addi $sp, $sp, -32  # Stack frame is 32 bytes long
    sw $ra, 20($sp)     # Save return address
    sw $fp, 16($sp)     # Save frame pointer
    addi $fp, $sp, 28   # Set up frame pointer by pointing to first word in bottom of frame

    li $v0, 13          # syscall to open a file $a0 - filename, $a1 = flags, $a2 = mode
    la $a0, file        # load name into $a0 (first argument)
    la $a1, 0           # flags = 0
    la $a2, 0           # mode = 0 (read-only)
    syscall             # execute syscall
    move $s0, $v0       # save file descriptor

    bltz $s0, errFile   # $v0 will return negative if no file is found

    jal closeFile       # jump and link close file

    li $v0, 4           # Testing String
    la $a0, yo          # 
    syscall             #

                        # Since the function calls are done, restore the return
                        # address and frame pointer.
    lw $ra, 20($sp)     # Restore return address
    lw $fp, 16($sp)     # Restore frame pointer
    addi $sp, $sp, 32   # Pop stack frame

    j exit              # jump to exit program

errFile:
    la $a0, errMsg      # testing if there is an error
    la $a1, file        #
    jal printf          #

    j exit

closeFile:
    li $v0, 4
    la $a0, closing
    syscall

    li $v0, 16          # syscall to close a file
                        # empty out the file directory
    syscall             # execute the call

    jr $ra

# exit gracefully

exit:
    li $v0, 4           # print test exiting string
    la $a0, exiting     # 
    syscall             #

    li $v0, 10          # syscall to exit program
    syscall             # execute the call

########################
#  printf Subroutines  #
########################

# printf.s  
# purpose:  MIPS assembly implementation of a C-like printf procedure 
# supports %s, %d, and %c formats up to 3 formats in one call to printf
# all arguments passed in registers (args past 3 are ignored)

# Register Usage: 
#    $a0,$s0 - pointer to format string 
#    $a1,$s1 - format arg1 (optional) 
#    $a2,$s2 - format arg2 (optional) 
#    $a3,$s3 - format arg3 (optional) 
#    $s4  - count of format strings processed so far
#    $s5  - holds the format string (%s,%d,%c,%) 
#    $s6  - pointer to printf buffer
#

.text 
.globl printf

printf:
   subu  $sp, $sp, 36       # setup stack frame
   sw    $ra, 32($sp)       # save local environment
   sw    $fp, 28($sp)       # frame pointer
   sw    $s0, 24($sp)       # save $s registers
   sw    $s1, 20($sp)       # Callee is responsible for saving
   sw    $s2, 16($sp)       #   then restoring the $s registers.
   sw    $s3, 12($sp) 
   sw    $s4, 8($sp) 
   sw    $s5, 4($sp)
   sw    $s6, 0($sp)  
   addu  $fp, $sp, 36        # Modify the frame pointer.
                             # It was pushed onto the stack above to save it.

                             # grab the args and move into $s0..$s3 registers
   move $s0, $a0             # fmt string
   move $s1, $a1             # arg1 (optional)
   move $s2, $a2             # arg2 (optional)
   move $s3, $a3             # arg3 (optional)

   li   $s4, 0               # set argument counter to zero
   la   $s6, printf_buf      # set s6 to base of printf buffer

main_loop:                    # process chars in fmt string
   lb   $s5, 0($s0)           # get next format flag
   addu $s0, $s0, 1           # increment $s0 to point to next char
   beq  $s5, '%', printf_fmt  # branch to printf_fmt if next char equals '%'
   beq  $0, $s5, printf_end   # branch to end if next char equals zero 

printf_putc: 
   sb   $s5, 0($s6)           # if here we can store the char(byte) in buffer 
   sb   $0, 1($s6)            # store a null byte in the buffer
   move $a0, $s6              # prepare to make printf_str(4) syscall  
   li   $v0, 4                # load integer 4 into $v0 reg              
   syscall                    # make the call
   b    main_loop             # branch to continue the main loop

printf_fmt: 
   lb   $s5, 0($s0)           # load the byte to see what fmt char we have 
   addu $s0, $s0, 1           # increment $s0 pointer 

   beq  $s4, 3,  main_loop    # if $s4 equals 3 branch to main_loop 
   beq  $s5,'d', printf_int   # decimal integer 
   beq  $s5,'s', printf_str   # string 
   beq  $s5,'c', printf_char  # ASCII char 
   beq  $s5,'%', printf_perc  # percent 
   b    main_loop             # if we made it here just continue 


printf_shift_args:            # code to shift to next fmt argument
   move  $s1, $s2             # assign $s2 to $s1 
   move  $s2, $s3             # assign $s3 to $s2 
   add   $s4, $s4, 1          # increment arg count
   b     main_loop            # branch to main_loop

printf_int:                   # print decimal integer
   move  $a0, $s1             # move $s1 into $v0 for print_int syscall
   li    $v0, 1               # load syscall no. 1 into $v0
   syscall                    # execute syscall 1
   b     printf_shift_args    # branch to printf_shift_args to process next arg

printf_str:
   move  $a0, $s1             # move buffer address $s1 to $a0 for print_str(4) 
   li    $v0, 4               # setup syscall - load 4 into $v0 
   syscall
   b    printf_shift_args     # branch to shift_arg loop

printf_char:                  # print ASCII character 
   sb    $s1, 0($s6)          # store byte from $s1 to buffer $s6
   sb    $0,  1($s6)          # store null byte in buffer $s6
   move  $a0, $s6             # prepare for print_str(1) syscall
   li    $v0, 4               # load 1 into $v0
   syscall                    # execute syscall 1
   b     printf_shift_args    # branch to printf_shift_args to process next arg

printf_perc: 
   li   $s5, '%'              # handle %%
   sb   $s5, 0($s6)           # fill buffer with byte %
   sb   $0, 1($s6)            # add null byte to buffer 
   move $a0, $s6              # prepare for print_str(4) syscall
   li   $v0, 4              
   syscall                    # execute the call
   b    main_loop             # branch to main_loop

printf_end:             # callee needs to clean up after itself
   lw   $ra, 32($sp)    # load word at address $sp+32 into return address reg 
   lw   $fp, 28($sp)    # load word at address $sp+28 into frame pointer reg 
   lw   $s0, 24($sp)    # restore values at addresses $sp+24 ... $sp+0 
   lw   $s1, 20($sp)    # ...
   lw   $s2, 16($sp)    # 
   lw   $s3, 12($sp)    # 
   lw   $s4,  8($sp)    # 
   lw   $s5,  4($sp)    # 
   lw   $s6,  0($sp)    # 
   addu $sp, $sp, 36    # release the stack frame
   jr   $ra             # jump to the return address


.data 

printf_buf:     .space 2

# end of print.s
