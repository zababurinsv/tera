## 86.ShadowBank (mixer)
Blockchain-based payment systems often have problems with anonymity. This is due to the fact that all information is stored in the blockchain in the clear and that you can trace all transactions from one account to another.

We offer two options for solving this problem:
- Use a money mixer (when amounts from different accounts are mixed with each other through a single smart contract account)
- Use encrypted transactions, so that the information in the clear form is not stored in the blockchain

DApp works on the principle of a bank. You can store money there (without a time limit), you can make unlimited withdrawal, as well as make intra-bank transfers (from one deposit to another).

## Deposits

You open a deposit, the number of which coincides with the account number in your wallet. Opening a deposit occurs by sending the amount of money. Dapp has a limit on the minimum value to be replenished (1000 Tera), it is displayed on the Deposit tab and is visible at the time of transfer.

At any time, you can replenish your deposit account by simply sending more coins to the same deposit number.

You can find out the deposit balance by clicking the Refresh button next to the deposit number

After that, the program will analyze the blockchain and find the last known balance on this account. The balance is not stored in the clear, it is visible only to the account holder (encrypted with the wallet’s private key).
If the balance is found, then the information on the deposit will be displayed as an additional line “(DEP: XXXX)

## Money transfers

In order to withdraw money to another account, the Orders tab is used. In it you enter the deposit number, the account to which you want to transfer money and the amount. A fee is taken for the transfer. Information about the fee charged is visible at the time of the transfer.


The command to send an order is executed anonymously, it does not have an open link to the account number, and all the information necessary to complete the operation is encrypted (only a bank can read it).

In addition to specifying a standard account, you can check the box “Intrabank transfer to another deposit”. In this case, the transfer will be made inside the bank (smart contract), and since the information on the transfers is encrypted, nothing will be visible in the public domain. The payee can make sure that the payment is made by going to the dapp on the Orders tab and click on the refresh button next to the account. At the same time, he does not need to completely bind the smart contract to the account - the link is only needed at the time of replenishment of the deposit, in the future it is not needed and it can be removed at any time, and then re-set if necessary.

### The bank (owner) of the smart contract has the right to set:

- A sign that the bank is open to accept deposits
- Minimum deposit replenishment amount
- Size of fee for each transfer order


More detail:

ENG: 
https://terafoundation.org/files/dapps/ShadowBank-ENG.pdf

RUS:
https://terafoundation.org/files/dapps/ShadowBank-RUS.pdf
