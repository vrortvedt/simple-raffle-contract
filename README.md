# simple-raffle-contract
A simple raffle Solidity contract that can be replayed without redeploying.  It uses a pseudo random number generator to choose a winner from among the participants.

It restricts duplicate entries within the same raffleCount, but once a winner is picked and a new raffle opened, participants who have entered earlier raffles may play again. 

This contract was written as a simple repetitive game to use in testing out the accretive utility token issuance model (https://github.com/vrortvedt/accretive-issuance-token-standard).
