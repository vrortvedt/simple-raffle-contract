pragma solidity ^0.4.24;

contract SimpleRaffle {
    
    struct Raffle {
        uint raffleCount;
        address[] participants;
        uint mintedTokens;
        uint raffleWinnerIndex;
        bool open;
    }
    
    address public developer;
    address public winner;
    
    Raffle public raffles;

    constructor() public {
        developer = msg.sender;
        raffles.open = false;
        raffles.raffleCount = 0;
    }

    modifier onlyDevs() {
        require(msg.sender == developer);
        _;
    }

/**
* @dev Allows the developer who deployed the contract to open a raffle event.
* @dev Requires that there is no currently open raffle, and increments the raffleCount by 1.  Also deletes array containing 
* @dev participants' ethereum addresses from the prior raffle.
*/

    function openEvent() public onlyDevs {
        require(!raffles.open);
        raffles.open = true;
        raffles.raffleCount = raffles.raffleCount + 1;
        delete raffles.participants;
    }

/**
* @dev Allows players to enter opened raffles.  Prohibits the developer from entering and prohibitss multiple raffle entries
* @dev from the same ethereum address through the canEnter function.  Adds entered players to raffle participants array.
*/

    function enter() external payable {
        require(raffles.open);
        require(msg.sender != developer);
        require(canEnter());
        raffles.participants.push(msg.sender);
        }

/**
* @dev Allows the developer to end an opened raffle with at least two entrants and chooses a winner using the pseudoRandom 
* @dev function.  It also mints one token per entrant.
* @return An ethereum address corresponding to the winning index number. 
*/

    function pickWinner() public onlyDevs returns (address) {
        require(raffles.participants.length > 1);
        raffles.open = false; 
        raffles.mintedTokens = raffles.participants.length;
        raffles.raffleWinnerIndex = pseudoRandom() % raffles.participants.length;
        return winner = raffles.participants[raffles.raffleWinnerIndex];
    }

/**
* @dev Generates a pseudo-random number based on a hash of three elements: the current block difficulty, the current timestamp,   Restricts the developer from entering and prevents duplicate entries
* @dev and the ethereum address of the first plyer to enter the raffle.  This is not, nor is it intended to be, secure.  
* @dev Do not use for any applications where real value may be at stake.
* @return A uint representing the result of the hash function on the three elements. 
*/

    function pseudoRandom() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, raffles.participants[0]));
    }

/**
* @dev Function to get a list of the entrants' ethereum addresses.
* @return An array containing the entrants' ethereum addresses.
*/
    function getParticipants() public view returns (address[]) {
        return raffles.participants;
    }

/**
* @dev Function to confirm that a player has not already entered an open raffle.
* @return A boolean value that passes as true only when the player's ethereum address is not in the array of current participants.
*/

    function canEnter() public view returns (bool) {
        for(uint i=0; i < raffles.participants.length; i++) {
            require(raffles.participants[i] != msg.sender);
        }
        return true;
    }
}
