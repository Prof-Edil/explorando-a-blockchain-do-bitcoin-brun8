# How many new outputs were created by block 123,456?
blockhash=$(bitcoin-cli getblockhash 123456)
block=$(bitcoin-cli getblock $blockhash 2)
# echo $block | jq

# array com todos vout de todos tx
echo $block | jq '[.tx[].vout[]] | length'

# done
