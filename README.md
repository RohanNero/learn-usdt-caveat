## USDT Caveat

Simple repository used to increase the understanding of USDT and how it fails to conform to the ERC-20 standard.

### Tests

We must pass an RPC URL to fork mainnet where the contracts in the demonstration exist ([Alchemy](https://dashboard.alchemy.com/) offers them for free).

```shell
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/<API_KEY>
```

### Companion Guide

https://medium.com/@rohanzarathustra/usdts-broken-promise-379f52915e86