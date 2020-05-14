#pragma warning(disable : 4996)

#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>

extern "C" void my_strncpy(char* src, char* dst, const int len);

int my_strlen(char* string) {
	int len;

	__asm {
		mov edi, [string]
		xor	ecx, ecx
		xor	al, al
		not ecx
		repne scasb

		not ecx
		dec	ecx
		
		mov len, ecx
	}

	return len;
}

int main(void) {
	char str[6] = "test";
	char test[6] = { 0 };
	int res = my_strlen(str);
	
	std::cout << res << std::endl;

	my_strncpy(str, test, res);
	std::cout << test << " : " << res << std::endl;

	return 0;
}
