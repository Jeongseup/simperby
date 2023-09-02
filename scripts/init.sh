#!/usr/bin/env bash

###############################
########## init chain #########
###############################
chain_dir="$HOME/ethcon-chain"
server_dir="$chain_dir/server"
client1_dir="$chain_dir/client1"
client2_dir="$chain_dir/client2"
client3_dir="$chain_dir/client3"

# remove previous data
rm -rf $chain_dir

bash setup.sh
# bash server_run.sh
# bash block.sh