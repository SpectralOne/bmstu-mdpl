#pragma warning(disable : 4996)

#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>

extern "C" void my_strncpy(const char* src, char* dst, const int len);

int my_strlen(const char* string) {
	int len;

	__asm {
		mov edi, [string]
		xor ecx, ecx
		xor al, al
		not ecx
		repne scasb

		not ecx
		dec ecx
		
		mov len, ecx
	}

	return len;
}

int main(void) {
	std::string str;
	std::cin >> str;

	int len = my_strlen(str.c_str());

	char test[6] = { 0 };
	my_strncpy(str.c_str(), test, len);

	std::cout << test << " : " << len << std::endl;

	return 0;
}
