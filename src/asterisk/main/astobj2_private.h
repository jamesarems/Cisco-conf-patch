/*
 * astobj2 - replacement containers for asterisk data structures.
 *
 * Copyright (C) 2006 Marta Carbone, Luigi Rizzo - Univ. di Pisa, Italy
 *
 * See http://www.asterisk.org for more information about
 * the Asterisk project. Please do not directly contact
 * any of the maintainers of this project for assistance;
 * the project provides a web site, mailing lists and IRC
 * channels for your use.
 *
 * This program is free software, distributed under the terms of
 * the GNU General Public License Version 2. See the LICENSE file
 * at the top of the source tree.
 */

/*! \file
 *
 * \brief Common, private definitions for astobj2.
 *
 * \author Richard Mudgett <rmudgett@digium.com>
 */

#ifndef ASTOBJ2_PRIVATE_H_
#define ASTOBJ2_PRIVATE_H_

#include "asterisk/astobj2.h"

#if defined(AO2_DEBUG)
#define AO2_DEVMODE_STAT(stat)	stat
#else
#define AO2_DEVMODE_STAT(stat)
#endif	/* defined(AO2_DEBUG) */

#ifdef AO2_DEBUG
struct ao2_stats {
	volatile int total_objects;
	volatile int total_mem;
	volatile int total_containers;
	volatile int total_refs;
	volatile int total_locked;
};
extern struct ao2_stats ao2;
#endif	/* defined(AO2_DEBUG) */

int is_ao2_object(void *user_data);
enum ao2_lock_req __adjust_lock(void *user_data, enum ao2_lock_req lock_how, int keep_stronger);

#endif /* ASTOBJ2_PRIVATE_H_ */
