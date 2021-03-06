#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2021.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Wed Dec 22 18:15:51 MSK 2021
# SW Build 3247384 on Thu Jun 10 19:36:07 MDT 2021
#
# IP Build 3246043 on Fri Jun 11 00:30:35 MDT 2021
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 3514483129bd4650938e6e36b8c67f32 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot test_behav xil_defaultlib.test -log elaborate.log"
xelab -wto 3514483129bd4650938e6e36b8c67f32 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot test_behav xil_defaultlib.test -log elaborate.log

