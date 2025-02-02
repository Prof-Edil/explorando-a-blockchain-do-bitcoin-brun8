# Only one single output remains unspent from block 123,321. What address was it sent to?
block_hash=$(bitcoin-cli getblockhash 123321)
block=$(bitcoin-cli getblock $block_hash)
readarray -t transactions_arr < <(echo $block | jq -r .tx[])

for t_id in "${transactions_arr[@]}"
do
    transaction=$(bitcoin-cli getrawtransaction "$t_id" 1 | jq -c)
    readarray -t vout_arr < <(echo "$transaction" | jq -c .vout[])
    for output in "${vout_arr[@]}"
    do
        vout_idx=$(echo $output | jq -r .n)
        # gettxout só tem resposta se o output nao tiver sido gasto
        res=$(bitcoin-cli gettxout $t_id $vout_idx)
        if [[ $res ]]
        then
          # se achou imprime e termina o programa
          addr=$(echo $res | jq -r .scriptPubKey.address)
          echo $addr
          exit 0
        fi
    done
done

