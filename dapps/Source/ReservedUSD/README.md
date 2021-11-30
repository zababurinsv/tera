## 113.ReservedUSD v.2

https://terawallet.org/dapp/113

************************************************************************************************************************

ReservedUSD is a protocol for the decentralized issuance of the USD token on the Tera blockchain platform. The exchange rate is pegged to the real currency USD, and its stability is ensured by the reserve fund of the collateral asset. Having a reliable stablecoin protocol is very important for the development of the blockchain ecosystem. It is useful for traders and for other smart contracts that require the Oracle of the TERA rate.

#####  News about  stable coin dapp 113 ReservedUSD.
```
25.02.2021
We have changed the reserve ratio of dapp 113 ReservedUSD to 0.003. Next week it will be increased to 0.005 more

18.02.2021
We plan to constantly change the reserve ratio following the exchange rate on the exchanges. 
When the coefficient changes, the size of all issued USD  changes proportionally - if the coefficient increases, 
the pools increase. In the near future, we want to increase the coefficient from 0.001 to 0.002, 
and then a week later to 0.003. Within six months, the coefficient will be adjusted manually - by me, but then, 
if USD shows itself on the good side, then we will introduce a voting mechanism through the DAO, 
abandon manual regulation and updates to make this dapp really decentralized (even from develop).
```

###Links


[ReservedUSD WP](https://terafoundation.org/files/dapps/ReservedUSD-ENG.pdf)
[ReservedUSD in practice use](https://terafoundation.org/files/dapps/ReservedUSD-Rate-ENG.pdf)

RUS:
[RUS ReservedUSD WP](https://terafoundation.org/files/dapps/ReservedUSD.pdf)
[RUS ReservedUSD in practice use](https://terafoundation.org/files/dapps/ReservedUSD-Rate.pdf)



###For Developers



Software architecture:
* ReservedUSD - main dapp with proxy to service smarts
* AutoCoin - a coin with a software-controlled issue
* CoinWalletLib - currency account management library
* VoteLib - vote  management library

*MathModel - The same formulas that are used in a smart contract to quickly model economic situations.

To exchange the DAO for TERA (the DAO tokens are burned at the same time), the following formulas are used:

```js
    TeraWithdrawn = DAOBurned * (1+DAOAllAmount/FeeAllAmount);
```

State format: 
```js
 {KFee:double, TWPrice:{Price:double,TimeStamp:uint}, TeraPool:double,USDPool:double}
```

How to use this smart contract from other dapps:

```js
"public"
function GetOraclePrice(Params)
{
    //var AccNum=446;//testnet
    var AccNum=226012;//mainnet
    var State=ReadState(AccNum);
    
    //Current swap fee:
    //State.KFee;

    //Pools:
    //State.TeraPool;
    //State.USDPool;
    var Price=State.USDPool/State.TeraPool;

    
    //Time weight price
    //State.TWPrice.Price;
    //State.TWPrice.TimeStamp;
    //Params.TWPrice0 - saved value for the previous day
    var OraclePrice=(State.TWPrice.Price-Params.TWPrice0.Price)/(State.TWPrice.TimeStamp-Params.TWPrice0.TimeStamp);
    
    return {KFee:State.KFee, Price:Price2, OraclePrice:OraclePrice};
}

```


[How to create a simple smart contract on the TERA platform](https://youtu.be/BzFxAgWbGak)

