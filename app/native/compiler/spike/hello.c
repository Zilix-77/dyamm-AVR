// TEMP Spike A: proves exec-from-nativeLibraryDir on Android 10+.
// A PIE executable disguised as lib*.so (the documented packaging route).
// Deleted with the spike, not part of the product.
#include <stdio.h>

int main(void)
{
	printf("spike-hello-ok\n");
	return 0;
}
