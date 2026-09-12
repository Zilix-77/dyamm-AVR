/* Minimal equivalent of the Makefile-generated sim_core_config.h, for the
 * single-core Android build. Upstream generates CONFIG_* per core plus
 * CONFIG_SIMAVR_VERSION; of those, only CONFIG_SIMAVR_VERSION is consumed
 * (sim_vcd_file.c). Trace stays off. Mirror the generator if cores are added.
 */
#ifndef __SIM_CORE_CONFIG_H__
#define __SIM_CORE_CONFIG_H__

#define CONFIG_SIMAVR_VERSION "1.8"

#endif
