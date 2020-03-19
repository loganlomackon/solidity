pragma solidity ^0.4.24;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.4/ChainlinkClient.sol";

contract RandomExample is ChainlinkClient {
    
    address constant private LINK_ORACLE_ADDR = 0x7AFe1118Ea78C1eae84ca8feE5C65Bc76CcF879e;
    bytes32 constant private LINK_JOB_ID_ADDR = convertStringToBytes32("b00ed7210563488cbe5a3b7729c0ec72");
    
    constructor() payable public {
        setPublicChainlinkToken();
    }
    
    //Chainlink
    uint256 public randomNumber;
   
   function getRandom() payable public {
       Chainlink.Request memory req = buildChainlinkRequest(LINK_JOB_ID_ADDR, this, this.fulfill.selector);
       sendChainlinkRequestTo(LINK_ORACLE_ADDR, req, 1 * LINK);
   }
   
   function fulfill(bytes32 _requestId, uint256 _data) public recordChainlinkFulfillment(_requestId) {
       randomNumber = _data%100;
   }
    
    function convertStringToBytes32(string memory source) pure returns (bytes32 result) {
       bytes memory tempEmptyStringTest = bytes(source);
       if (tempEmptyStringTest.length == 0) {
           return 0x0;
       }
       
       assembly {
           result := mload(add(source, 32))
       }
   }
   
}
