pragma solidity ^0.4.17;

contract Lottery {
    // variables
    // manager address 
    address public manager;
    address[] public players;

    function Lottery() public {
        // we set the sender of the create contract transaction - msg.sender - as the "manager/owner" of the contract
        manager = msg.sender; 
    }

    function enter() public payable {
        // require is a global variable available in solidity, if require is given a falsy value it will exit the function
        require(msg.value > .01 ether);
        // we add the sender of the transaction to the players array
        players.push(msg.sender);
    }

    // this function is a pseudo-random-number generator. solidity has problems with randomness. this could be exploited if used in an actual app
    function random() private view returns (uint) {
        // keccak256 = sha3, hashing algorithms. the arguments are our hashing parameters, block difficulty, time and players array length
        return uint(keccak256(block.difficulty, now, players));
    }

    // we use the "restricted" keyword (name of modifier) to implement the modifier function
    function pickWinner() public restricted {
        // picks a "randomized" player
        uint index = random() % players.length;
        // transfers all money from the contracts balance to the chosen address/player
        players[index].transfer(this.balance); 
        // after picking winner, set players array to an new dynamic array of addresses that is empty, with initial size of 0 
        players = new address[](0);
    }

    // function modifier, acts as a middleware function to prevent code repetition
    modifier restricted() {
        // require "authentication" so that only the manager can call this function
        require(msg.sender == manager);
        // _ means to run the rest of the function after this validation passes
        _;
    }

    // short function to get list of players participating in the current lottery
    function getPlayers() public view returns (address[]) {
        return players;
    }
}