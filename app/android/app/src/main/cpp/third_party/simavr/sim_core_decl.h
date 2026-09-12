/* Single-core equivalent of the Makefile-generated sim_core_decl.h.
 * Upstream generates extern declarations plus the avr_kind[] table for every
 * core that preprocesses cleanly; we vendor only mega32, so the table holds
 * one entry. AVR_KIND_DECL is set via CMake so sim_avr.c emits the table once.
 */
#ifndef __SIM_CORE_DECL_H__
#define __SIM_CORE_DECL_H__

#include "sim_core_config.h"

extern avr_kind_t mega32;
extern avr_kind_t * avr_kind[];
#ifdef AVR_KIND_DECL
avr_kind_t * avr_kind[] = {
	&mega32,
	NULL
};
#endif
#endif
