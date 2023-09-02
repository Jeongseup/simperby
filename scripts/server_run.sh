#!/env/bin/bash

chain_dir="$HOME/ethcon-chain"
server_dir="$chain_dir/server"
client1_dir="$chain_dir/client1"
client2_dir="$chain_dir/client2"
client3_dir="$chain_dir/client3"


# server up
simperby-cli $server_dir serve
