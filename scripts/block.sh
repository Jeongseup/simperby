#!/env/bin/bash

set -ux

chain_dir="$HOME/dev-chain"
server_dir="$chain_dir/server"
client1_dir="$chain_dir/client1"
client2_dir="$chain_dir/client2"
client3_dir="$chain_dir/client3"
# server run


# add peers
simperby-cli $client1_dir peer update && simperby-cli $client1_dir peer status
simperby-cli $client2_dir peer update && simperby-cli $client2_dir peer status
simperby-cli $client3_dir peer update && simperby-cli $client3_dir peer status

# post txs
simperby-cli $client1_dir post-transaction LineaTestnet 0 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847 100000 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847
simperby-cli $client1_dir post-transaction LineaTestnet 1 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847 100000 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847
simperby-cli $client1_dir post-transaction LineaTestnet 2 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847 100000 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847

# create agenda
simperby-cli $client1_dir create agenda

# sync_each_other
simperby-cli $client1_dir broadcast && sleep 1 && simperby-cli $client1_dir update
simperby-cli $client2_dir broadcast && sleep 1 && simperby-cli $client2_dir update
simperby-cli $client3_dir broadcast && sleep 1 && simperby-cli $client3_dir update

# vote
cd $client1_dir && branch=$(git branch | sed -n '2p' | tr -d '[:space:]')
echo "current agenda: $branch"

simperby-cli $client1_dir vote $branch
simperby-cli $client2_dir vote $branch
simperby-cli $client3_dir vote $branch

# sync_each_other

# create block
simperby-cli $client1_dir create block

# sync 
echo "start sync_each_other" && \
    simperby-cli $client1_dir broadcast && \
    sleep 1 && \
    simperby-cli $client1_dir update && \
    sleep 1 && \
    simperby-cli $client2_dir broadcast && \
    sleep 1 && \
    simperby-cli $client2_dir update && \
    sleep 1 && \
    simperby-cli $client3_dir broadcast && \
    sleep 1 && \
    simperby-cli $client3_dir update

# consensus
simperby-cli $client1_dir consensus
simperby-cli $client2_dir consensus
simperby-cli $client3_dir consensus
