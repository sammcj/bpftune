#!/usr/bin/bash
#
# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
#
# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.

# run sysctl test

. ./test_lib.sh


SLEEPTIME=10

for TUNER in neigh_table ; do

   test_start "$0|sysctl test: does setting sysctl switch off tuner?"

   test_setup "true"

   test_run_cmd_local "$BPFTUNE -ds &" true

   sleep $SETUPTIME
   for SYSCTL in net.ipv4.neigh.default.gc_thresh1 kernel.core_pattern ; do
	val="$(sysctl -qn $SYSCTL)"
	sysctl -qw ${SYSCTL}="${val}"
   done
   sleep $SLEEPTIME
   grep "modified sysctl" $TESTLOG_LAST
   test_pass

   test_cleanup
done

test_exit
