/*
Lawrence Marquez
CMPS 2240 - Assembly Language
Lab 4 ?
 */

#include <stdio.h>
#include <stdlib.h>
const char filename[] = "/usr/share/dict/cracklib-small";

int main() {
    printf("Program is starting...\n");
    FILE *fpi;

    fpi = fopen(filename, "r");

    if(!fpi) {
        printf(" ERROR - opening %s\n", filename);
        exit(0);
    }

    // Reading the word of the Dictionary
    // not a static array
    // use malloc instead of new like other languages
    char *dict = malloc(512000 * sizeof(char)); // safest way to do it
    int ret = fread(dict, 1, 512000, fpi);
    dict[ret] = '\0'
    fclose()
    // printf("%s", dict); // does all the words
    char *d = dict;
    char *p = d;

    while(*p != '\0') {

        while(*p != '\n') {
        ++p;
        }
    

        *p = '\0';

        printf("first word: **%s**\n", d);
        d = p = p + 1;
    }
    return 0;

}