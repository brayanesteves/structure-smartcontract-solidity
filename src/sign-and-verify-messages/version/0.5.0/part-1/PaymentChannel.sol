pragma solidity >=0.4.21 <0.6.0;

contract PaymentChannel {
    address owner;
    mapping(uint256 => bool) usedNonces;

    constructor() public payable {
        owner = msg.sender;
    }

    function moreMoney() public payable {
        require(msg.sender == owner);
    }

    function claimPayment(uint256 _amount, uint256 _nonce, bytes memory _sig) public {
        /**
         * [ESP] Comprobación de que este pago no ha sido utilizado. 
         */
        require(!usedNonces[_nonce], "Payment Used");
        usedNonces[_nonce] = true;

        /**
         * [ESP] Recrear el 'hash' del pago.
         */
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, _amount, _nonce, address(this)));
                hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        
        /**
         * [ESP] Comprobar que quien afirmado el pago.
         */
        require(recoverSigner(hash, _sig) == owner);

        msg.sender.transfer(_amount);
    }

    function splitSignature(bytes memory sig) internal pure returns(uint8, bytes32, bytes32) {
        
        require(sig.length == 65);
        
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            /**
             * [ENG] First 32 bytes, after the length prefix.
             */
            r := mload(add(sig, 32))
            /**
             * [ENG] Second 32 bytes.
             */
            s := mload(add(sig, 64))
            /**
             * [ENG] Final byte (First byte of the next 32 bytes).
             */
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns(address) {
        
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(sig);

        return ecrecover(hash, v, r, s);
    }


}