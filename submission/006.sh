# Which tx in block 257,343 spends the coinbase output of block 256,128?
origin_block=$(bitcoin-cli getblockhash 256128)

coinbase_vout=0
coinbase=$(bitcoin-cli getblock $origin_block | jq -r .tx[0])

block_hash=$(bitcoin-cli getblockhash 257343)
all_transactions=$(bitcoin-cli getblock $block_hash | jq -r .tx[])

# sem essa declaracao entra em loop aparentemente

# pra cada id de transação
for t_id in $all_transactions
do
  # busca a transação e extrai os inputs, -c pro array vir compactado
  readarray -t t_inputs < <(bitcoin-cli getrawtransaction $t_id 1 | jq -c .vin[])

  # para cada input
  for input in "${t_inputs[@]}"
  do
    current_txid=$(echo "$input" | jq -r .txid)
    current_vout=$(echo "$input" | jq -r .vout)

    if [[ $coinbase == $current_txid && $coinbase_vout == $current_vout ]]
    then
      echo $t_id
      exit 0
    fi

  done
done

# done
