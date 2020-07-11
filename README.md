# TransferWise Currency Alert

A bash script to check the conversion rate between two
currencies and notify you using `spd-say` utility

# Installation

```bash
git clone git@github.com:bitriddler/transferwise-currency-alert
cd ./transferwise-currency-alert
```

# Usage

```bash
$ ./run.sh [SourceCurrency] [TargetCurrency] [Threshold] [Every]
```

# Example

Checking conversion rate from `EUR` to `EGP` every `30`
seconds and raises an alert when it's over `18.2`

```bash
./run.sh EUR EGP 18.2 30
```

# License

MIT
