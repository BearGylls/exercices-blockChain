pragma solidity ^0.5.7;

library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


contract Cogere{
  mapping (address => uint) organisateurs;
  mapping (address => bool) isOrga;
 
  constructor() public {
    organisateurs[msg.sender] = 100;
    isOrga[msg.sender]=true;
  }
 
 function transfererOrga(address _orga, uint _parts) public {
    require(isOrga[msg.sender]); 
    organisateurs[msg.sender] -= _parts;
    organisateurs[_orga] += _parts;
    isOrga[_orga]=true;
 }

 function estOrga(address _orga) public view returns (bool){ 
     return isOrga[_orga];
 }
}

contract CagnotteFestival is Cogere {
    uint private depensesTotales;
    string[] sponsors;
    uint placesRestantes = 500;
    mapping (address => bool) festivaliers;
    using SafeMath for uint256;

    function comptabiliserDepense(uint _montant) private {
      depensesTotales += _montant;
    }    

    function acheterTicket() public payable {
        require(msg.value>= 500 finney,"Place à 0.5 Ethers");
        require(placesRestantes>0,"Plus de places !");
        festivaliers[msg.sender]=true;
        placesRestantes--;
      }
    
    
    function payer(address payable _destinataire) public payable{
        require(estOrga(msg.sender));
        require(_destinataire != address(0));
        require(msg.value > 0);
        _destinataire.transfer(msg.value);
      }

    function sponsoriser(string memory _nom) public payable {
        require(msg.value >= 30 ether);
        sponsors.push(_nom);
    }

    function lastSponsor() public view returns (string memory) {
      return sponsors[sponsors.length-1];
    }
}
