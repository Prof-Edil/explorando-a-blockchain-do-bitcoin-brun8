# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
id="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"
# true retorna a transação em json
transaction=$(bitcoin-cli getrawtransaction $id true)
key0=$(echo $transaction | jq .vin[0].txinwitness[1])
key1=$(echo $transaction | jq .vin[1].txinwitness[1])
key2=$(echo $transaction | jq .vin[2].txinwitness[1])
key3=$(echo $transaction | jq .vin[3].txinwitness[1])

# 1 assinatura, array de chaves, "legacy" por padrao
# sig=$(bitcoin-cli createmultisig 1 "[$key0, $key1, $key2, $key3]")
sig=$(bitcoin-cli createmultisig 1 "[$key0, $key1, $key2, $key3]" | jq -r .address)

echo $sig

