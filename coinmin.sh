#/usr/bin/bash



function coinmin(){

  YELLOW=$(tput setaf 3)
  GREEN=$(tput setaf 2)
  RED=$(tput setaf 1)
  GREY=$(tput bold)$(tput setaf 0)
  RESET=$(tput sgr0 )
  
  echo $YELLOW"
          (_)               (_)
  ___ ___  _ _ __  _ __ ___  _ _ __
 / __/ _ \\| | '_ \\| '_ \` _ \\| | '_ \\ 
| (_| (_) | | | | | | | | | | | | | |
 \\___\\___/|_|_| |_|_| |_| |_|_|_| |_|
 "$RESET


  LIMIT="10"
  API="https://api.coinmarketcap.com/v1/ticker/?"
  FIELDS='rank\|symbol\|price_usd\|percent\|cap'

  BAR1="|------------------------------------------------------------------------------|\n"
  BAR2="|------|------------|--------------|----------|----------|----------|----------|\n"


  # Okay so I went HAM on the one liner...
  curl -s  $API"limit="$LIMIT |\
    grep $FIELDS  |\
    sed 's/ *"symbol": "\(.*\)"/- \1/' |\
    sed 's/^.*\": \"\(.*\)\"/\1/'   |\
    xargs echo | awk '{ split($0, coin, /- /);
      printf "'$BAR1'"
      printf "| Rank | Coin       | Price (USD)  "
      printf "| 24h +/-  | 1h +/-   | 7d +/-   | MktCap $ |\n"
      printf "'$BAR1'"
      for (i in coin){
          split(coin[i], c, /, /)
          if (c[2] != ""){
              printf "| %-5s| %-11s| %-13.4f| +%-8.2f| +%-8.2f| +%-8.2f| %-9.3f|\n", 
              c[2], c[1], c[3], c[6], c[5], c[7], (c[4]/1000000000)
              printf "'$BAR2'"
          }
      }      
    }' |\
    sed -E  "s/([A-Z0-9]+[a-z]+)|(\+\/\-)|(\(USD\))/"$YELLOW"\1\2\3"$RESET"/g"|\
    sed -E  "s/\+(\-[0-9.]+)/"$RED"\1 "$RESET"/g" |\
    sed -E  "s/(\+[0-9.]+)/"$GREEN"\1"$RESET"/g" |\
    sed -E  "s/(\|)|(--+)/"$GREY"\1\2"$RESET"/g"

}


coinmin $@

