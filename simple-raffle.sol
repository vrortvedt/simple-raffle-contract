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
    
    function openEvent() public onlyDevs {
        require(!raffles.open);
        raffles.open = true;
        raffles.raffleCount = raffles.raffleCount + 1;
        delete raffles.participants;
    }
    
    function enter() external payable {
        require(raffles.open);
        require(msg.sender != developer);
        require(canEnter());
        raffles.participants.push(msg.sender);
        }

    function pickWinner() public onlyDevs returns (address) {
        require(raffles.participants.length > 0);
        raffles.open = false; 
        raffles.mintedTokens = raffles.participants.length;
        raffles.raffleWinnerIndex = pseudoRandom() % raffles.participants.length;
        return winner = raffles.participants[raffles.raffleWinnerIndex];
    }
    
    function pseudoRandom() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, raffles.participants[0]));
    }

    function getParticipants() public view returns (address[]) {
        return raffles.participants;
    }
    
    function canEnter() public view returns (bool) {
        for(uint i=0; i < raffles.participants.length; i++) {
            require(raffles.participants[i] != msg.sender);
        }
        return true;
    }
}
