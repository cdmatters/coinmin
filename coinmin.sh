#usr/bin/bash




function coinmin(){

  LIMIT="10"
  API="https://api.coinmarketcap.com/v1/ticker/?"
  FIELDS='rank\|symbol\|price_usd\|percent\|cap'

  yellow=$(tput setaf 3)
  green=$(tput setaf 2)
  red=$(tput setaf 1)
  grey=$(tput bold)$(tput setaf 0)
  reset=$(tput sgr0 )
  
  curl -s  $API"limit="$LIMIT |\
    grep $FIELDS  |\
    sed 's/ *"symbol": "\(.*\)"/- \1/' |\
    sed 's/^.*\": \"\(.*\)\"/\1/'   |\
    xargs echo | awk '{ split($0, coin, /- /);
        
      printf "|------------------------------------------------------------------------------|\n"
      printf "| Rank | Coin       | Price (USD)  | 24h +/-  | 1h +/-   | 7d +/-   | MktCap $ |\n"
      printf "|------------------------------------------------------------------------------|\n"
      for (i in coin){
          split(coin[i], c, /, /)
          if (c[2] != ""){
              printf "| %-4s | %-10s | %-12.4f | +%-7.2f | +%-7.2f | +%-7.2f | %-8.3f |\n", 
              c[2], c[1], c[3], c[6], c[5], c[7], (c[4]/1000000000)
              printf "|------|------------|--------------|----------|----------|----------|----------|\n"
        }}       
      }' |\
    sed -E  "s/([A-Z0-9]+[a-z]+)/"$yellow"\1"$reset"/g" |\
    sed -E  "s/(\+\/\-)/"$yellow"\1"$reset"/g" |\
    sed -E  "s/(\(USD\))/"$yellow"\1"$reset"/g" |\
    sed -E  "s/(\+\-[0-9.]+)/"$red"\1"$reset"/g" |\
    sed -E  "s/(\+[0-9.]+)/"$green"\1"$reset"/g" |\
    sed "s/\|/"$grey"\|"$reset"/g" |\
    sed "s/--\(-*\)/"$grey"--\1"$reset"/g" 

}


coinmin $@

