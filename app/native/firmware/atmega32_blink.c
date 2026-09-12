// Intended source for atmega32_blink.hex (PRD §48, first test).
// No avr-gcc on this machine yet — the .hex was hand-assembled from these
// three instructions (verified by disassembly, see README.md). Rebuild with
// avr-gcc in Phase 4 and diff against this fixture.
#include <avr/io.h>

int main(void)
{
    DDRB |= (1 << PB0);   // sbi 0x17,0
    PORTB |= (1 << PB0);  // sbi 0x18,0
    while (1) { }         // rjmp .
}
