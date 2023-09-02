#!/env/bin/bash

set -ux

###############################
########## init chain #########
###############################

# make a dir
chain_dir="$HOME/ethcon-chain"
server_dir="$chain_dir/server"
client1_dir="$chain_dir/client1"
client2_dir="$chain_dir/client2"
client3_dir="$chain_dir/client3"

# remove previous data
rm -rf $chain_dir

# make directories
mkdir -p $server_dir
mkdir -p $client1_dir
mkdir -p $client2_dir
mkdir -p $client3_dir

# init
cd $server_dir && git init && simperby-cli $server_dir dump-genesis && rm keys.json
git add -A 
git config user.name "Jeongseup" 
git config user.email "seup87@gmail.com"
git commit -m "genesis"
git config receive.advertisePushOptions true 
git config sendpack.sideband false

###############################
########## server side ########
###############################

# make a genesis block
simperby-cli $server_dir genesis
simperby-cli $server_dir init

cp -a $server_dir/. $client1_dir/
cp -a $server_dir/. $client2_dir/
cp -a $server_dir/. $client3_dir/

###############################
########## server side ########
###############################

simperby-cli $server_dir dump-server-config
simperby-cli $server_dir dump-configs
jq '.private_key = "706a6cfa043cfbfb3cb8fe81c219732736a726aa28802838da0f0ed17913da14"' "$server_dir/.simperby/auth.json" > temp.json && \
    mv temp.json "$server_dir/.simperby/auth.json" && \
    cat $server_dir/.simperby/auth.json

###############################
########## client side ########
###############################

simperby-cli $client1_dir dump-configs && \
    jq '.private_key = "430090e9122e9edff073fa0fa7a465f67a9aad99b885fc484893f33b2a5593e9"' "$client1_dir/.simperby/auth.json" > temp.json && \
    mv temp.json "$client1_dir/.simperby/auth.json" && \
    cat $client1_dir/.simperby/auth.json

simperby-cli $client1_dir peer add "member-0003" 127.0.0.1:37000 


simperby-cli $client2_dir dump-configs && \
    jq '.private_key = "1f0090ed3240e03adec8e13baf6e2ebe725dc01ab0fc3894c92cf8cbb92f0e10"' "$client2_dir/.simperby/auth.json" > temp.json && \
    mv temp.json "$client2_dir/.simperby/auth.json" && \
    cat $client2_dir/.simperby/auth.json

simperby-cli $client2_dir peer add "member-0003" 127.0.0.1:37000

echo "setup client3 node: $client3_dir" && \
    simperby-cli $client3_dir dump-configs && \
    jq '.private_key = "f93383f699c79e8791c2f0ce777efca8d10c1fbf04426ce1f8dfcdc51c5455a1"' "$client3_dir/.simperby/auth.json" > temp.json && \
    mv temp.json "$client3_dir/.simperby/auth.json" && \
    cat $client3_dir/.simperby/auth.json && \
    simperby-cli $client3_dir peer add "member-0003" 127.0.0.1:37000 