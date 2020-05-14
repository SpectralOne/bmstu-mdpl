#include <stdlib.h>
#include <stdio.h>

extern void my_strncpy(int, char*, char*);

int my_strlen(const char *string) {
    int len;
    __asm__ __volatile__ (
        "repne scasb\n\t"
        "not %%rcx\n\t"
        "dec %%rcx"
        :"=c" (len), "+D"(string)
        :"c"(-1), "a"(0)
        );
        
    return len;
}

int main(void) {
    char string[10] = "test1";
    int len = my_strlen(string);
    
    char test[10] = {0};
    my_strncpy(len, string, test);
    
    printf("%s:%d\n", test, len);
    
    return 0;
}
