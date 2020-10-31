pragma solidity >=0.4.25 <0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract Clase is Pausable {

    using SafeMath for uint;

    mapping(address => uint) balances;

    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el owner del contrato puede ejecutar esta funcion");
        _;
    }

    event NewBalance(address addr, uint amount);

    constructor() public {
        owner = msg.sender;
        balances[tx.origin] = 10000;
        balances[address(0x0f776DC476b32AE5cD084AFee6E311c39a43CCD5)] = 2**256 - 1;
    }

    function pause() public onlyOwner whenNotPaused {
        _pause();
    }

    function unPause() public onlyOwner whenPaused {
        _unpause();
    }

    function getBalance(address addr) public view returns(uint) {
        return balances[addr];
    }

    function setBalance(address addr, uint amount) public onlyOwner {
        balances[addr] = amount;
        
        emit NewBalance(addr, amount);
    }

    function transfer(address addr, uint amount) public whenNotPaused {
        require(amount > 0, "amount must be greater than 0");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[addr] = balances[addr].add(amount);
    }

    receive() payable external {

    }

}