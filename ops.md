# simperby ops for ethkon

```bash
# make a dir
dir="~$HOME/.simperby-server" # or ~/.simperby-client
mkdir $dir

# init git
cd $dir && \
    git init && \
    simperby-cli $dir dump-genesis && \
    rm keys.json

# if need to change genesis info, modify genesis file
vi $dir/reserved/genesis_info.json
# And, if you want to add some files into genesis block, please copy & paste files which you want
mkdir -p $dir/genesis
cp <some-file> $dir/genesis

# genesis
git add -A && git commit -m "genesis"

# setup git config
cd $dir && git config receive.advertisePushOptions true
cd $dir && git config sendpack.sideband false

# make a genesis block
simperby-cli ~/server genesis
simperby-cli ~/server init

# push current git to github
git remote add origin https://github.com/Jeongseup/simperby-devnet.git
git branch -M finalized
git push --all
```


