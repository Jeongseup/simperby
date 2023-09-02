# simperby ops for ethkon
### Build
```bash
git clone git@github.com:Jeongseup/simperby.git
cargo build --bin simperby-cli --release && mv ./target/release/simperby-cli $HOME/.cargo/bin  
```

### Init chain
```bash
# make a dir
# chain_dirs="$HOME/ethcon-chain"
chain_dir="$HOME/dev-chain"
server_dir="$chain_dir/server"
client1_dir="$chain_dir/client1"
client2_dir="$chain_dir/client2"
client3_dir="$chain_dir/client3"

# make directories
mkdir -p $chain_dirs
mkdir -p $chain_dirs/server
mkdir -p $chain_dirs/client1
mkdir -p $chain_dirs/client2
mkdir -p $chain_dirs/client3

# init
git init && simperby-cli $server_dir dump-genesis && rm keys.json
git add -A && git commit -m "genesis"

# git config setup
git config user.name "Jeongseup"
git config user.email "seup87@gmail.com"
git config receive.advertisePushOptions true
git config sendpack.sideband false

# make a genesis block
simperby-cli $server_dir genesis
simperby-cli $server_dir init
```

### Serve Chain 
```bash
# server side
simperby-cli $server_dir dump-configs
simperby-cli $server_dir dump-server-config

# update private key
jq '.private_key = "706a6cfa043cfbfb3cb8fe81c219732736a726aa28802838da0f0ed17913da14"' "$server_dir/.simperby/auth.json" > temp.json && mv temp.json "$server_dir/.simperby/auth.json" && cat $server_dir/.simperby/auth.json
```

### Client Side
```bash
cp -a $server_dir/. $client1_dir/
cp -a $server_dir/. $client2_dir/
cp -a $server_dir/. $client3_dir/

simperby-cli $client1_dir dump-configs
jq '.private_key = "430090e9122e9edff073fa0fa7a465f67a9aad99b885fc484893f33b2a5593e9"' "$client1_dir/.simperby/auth.json" > temp.json && mv temp.json "$client1_dir/.simperby/auth.json" && cat $client1_dir/.simperby/auth.json

simperby-cli $client2_dir dump-configs
jq '.private_key = "1f0090ed3240e03adec8e13baf6e2ebe725dc01ab0fc3894c92cf8cbb92f0e10"' "$client2_dir/.simperby/auth.json" > temp.json && mv temp.json "$client2_dir/.simperby/auth.json" && cat $client2_dir/.simperby/auth.json

simperby-cli $client3_dir dump-configs
jq '.private_key = "f93383f699c79e8791c2f0ce777efca8d10c1fbf04426ce1f8dfcdc51c5455a1"' "$client3_dir/.simperby/auth.json" > temp.json && mv temp.json "$client3_dir/.simperby/auth.json" && cat $client3_dir/.simperby/auth.json
```

# Peering
```bash
# server up
simperby-cli $server_dir dump-server-config && simperby-cli $server_dir serve

# add peers
simperby-cli $client1_dir peer add "member-0003" 127.0.0.1:37000 && \
    simperby-cli $client1_dir peer update && \
    simperby-cli $client1_dir peer status

simperby-cli $client2_dir peer add "member-0003" 127.0.0.1:37000 && \
    simperby-cli $client2_dir peer update && \
    simperby-cli $client2_dir peer status

simperby-cli $client3_dir peer add "member-0003" 127.0.0.1:37000 && \
    simperby-cli $client3_dir peer update && \
    simperby-cli $client3_dir peer status
```

# create agenda (only client1) to > server
```bash
# post txs
simperby-cli $client1_dir post-transaction LineaTestnet 0 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847 100000 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847

simperby-cli $client1_dir post-transaction LineaTestnet 1 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847 100000 0xC9EC9bE9B6768c770F5f754fE5f6cB6804B68847

# create agenda
simperby-cli $client1_dir create agenda

# sync_each_other
simperby-cli $client1_dir broadcast && simperby-cli $client1_dir update
simperby-cli $client2_dir broadcast && simperby-cli $client2_dir update
simperby-cli $client3_dir broadcast && simperby-cli $client3_dir update
```


```bash
# vote
branch=$(git branch | sed -n '2p' | tr -d '[:space:]')
simperby-cli $client1_dir vote $branch
simperby-cli $client2_dir vote $branch
simperby-cli $client3_dir vote $branch

# create block
simperby-cli $client1_dir create block
```







