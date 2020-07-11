#!/bin/bash
re='^[0-9]+([.][0-9]+)?$'
sourceCurrency="$1"
targetCurrency="$2"
threshold="$3"
every="$4"

echo "Will check conversion rate from $sourceCurrency to $targetCurrency every ${every} seconds"
echo "When it's over this value $threshold we will notify you"

while true
do
  output=$(curl "https://transferwise.com/gateway/v3/comparisons?sendAmount=1000&sourceCurrency=${sourceCurrency}&targetCurrency=${targetCurrency}" \
    -H 'authority: transferwise.com' \
    -H 'pragma: no-cache' \
    -H 'cache-control: no-cache' \
    -H 'accept: application/json' \
    -H 'time-zone: Europe/Berlin' \
    -H 'accept-language: en' \
    -H 'x-authorization-key: dad99d7d8e52c2c8aaf9fda788d8acdc' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36' \
    -H 'content-type: application/json' \
    -H 'sec-fetch-site: same-origin' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-dest: empty' \
    -H 'referer: https://transferwise.com/de' \
    -H 'cookie: twCookieConsentGTM=true; _gcl_au=1.1.1335046909.1588361374; gid=3c0dd475-c6f5-4689-b47c-09096c028e98; _ga=GA1.2.1656476760.1588361386; _fbp=fb.1.1588361394082.7940507; _hjid=677ec84b-52bb-4189-be70-e565ef378db6; cacheID=20200507Xe26b4a09e4f8426f9d501dcae71ea7cf; _rdt_uuid=1590873853049.3acf772d-b499-41f6-9dff-495654cca2d7; localeData=en_GB; __cfduid=dd73b309371e489140afbd4f4efdc209e1594107088; twCookieConsent=%7B%22policyId%22%3A%222020-01-31%22%2C%22expiry%22%3A1609832594244%2C%22isEu%22%3Atrue%2C%22status%22%3A%22accepted%22%7D; __pdst=027795de3c5c414f850e86d74f2b6b8c; _scid=a5c327a2-2537-406e-9761-ee15738dc70e; _iz_uh_ps_=%7B%22vi%22%3Anull%2C%22pv%22%3A5%2C%22lv%22%3A%222020-07-07T08%3A00%3A20.839Z%22%2C%22pr%22%3A%222020-06-24T12%3A50%3A38.137Z%22%2C%22si%22%3A%5B%7B%22i%22%3A%22fghufilyfi%22%2C%22c%22%3A-1%2C%22m%22%3Afalse%2C%22s%22%3A0%2C%22l%22%3Anull%7D%2C%7B%22i%22%3A%22uyyrfgyliu%22%2C%22c%22%3A0%2C%22m%22%3Afalse%2C%22s%22%3A0%2C%22l%22%3Anull%7D%5D%7D; hasClickedOnSignUpOrLogin=true; rememberMe=true; selectedProfileId/7838799=5579864; selectedProfileId/3832501=2642213; fxuser=bCsvcmNodlZFL3Y2UE84S1NmM1RuUT09OkNndzYrOExhTTJzby9rakV0NDZ2QWhnPT0; usr=3832501-8mgk-fb43d7654f23f572678eb0e90908f20d; appToken=dad99d7d8e52c2c8aaf9fda788d8acdc; analytics=%7B%22userId%22%3A%2217339adf2617fc-0d81f72994ae88-132f180f-144000-17339adf26288d%22%7D; _gid=GA1.2.1103611522.1594400572; _dc_gtm_UA-16492313-1=1; _uetsid=fbe01fe2-f32e-c50a-8fa8-98ea300783f7; _uetvid=c199436b-7704-9c5b-5030-20674bd44467' \
    -s \
    --compressed | jq '.providers | .[] | select(.alias == "transferwise") | .quotes | map(.rate | tostring) | join(",")' -r)

  echo "Conversion rate is: ${output}"

  if ! [[ $output =~ $re ]] ; then
    echo "error: Not a number"
    spd-say "Error: Not a number"
  elif (( $(echo "$output >= $threshold" | bc -l) )) ; then
    spd-say "${output}"
  fi
  sleep ${every}
done

