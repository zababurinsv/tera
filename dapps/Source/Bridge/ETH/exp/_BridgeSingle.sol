// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;
pragma experimental ABIEncoderV2;



//import "./TokenLib.sol";
//import "./OrderLib.sol";
//import "./NotaryLib.sol";

//import "./OwnerLib.sol";
//import "./StorageLib.sol";
//import "./DataLib.sol";
//import "./TypeLib.sol";
//import "./ConvertLib.sol";


//import "./token/ERC20/IERC20.sol";
//import "./token/ERC721/IERC721.sol";
//import "./token/ERC1155/IERC1155.sol";



interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
      * - `from` cannot be the zero address.
      * - `to` cannot be the zero address.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}




contract TypeLib
{
    //uint constant CONSENSUS_PERIOD_TIME = 3;
    //uint constant FIRST_TIME_BLOCK = 1593818071;//const from TERA 1/1000        Main-net:1403426400     Test-net: 1593818071

    uint constant BUF_SIGN    = 1;
    uint constant BUF_STORE   = 2;
    uint constant BUF_EXTERN_FULL  = 3;
    uint constant BUF_EXTERN_HEADER = 4;

    uint constant ERC_SKIP = 1;
    uint constant ERC_MINT = 2;
    uint constant ERC_OTHER = 3;

    struct TypeCommon
    {
        uint8  WORK_MODE;
        uint8 CONSENSUS_PERIOD_TIME;
        uint32 FIRST_TIME_BLOCK;//const from TERA 1/1000        Main-net:1403426400     Test-net: 1593818071
        uint24 MAX_SIGN_PERIOD;
        uint24 MAX_TRANSFER_PERIOD;
        uint8 NOTARY_COUNT;
        uint8 MIN_SIGN_COUNT;

        uint48 MinNotaryFee;//мин. комиссия с точностью 1e-9
        uint48 NotaryFee;//коэффициент нотариальной комисии с точностью 1e-9
        uint48 MinDeposit;//мин депозит с точностью 1e-9


        uint16 SlashRate;//множитель слэшинга (тока целые множители)
        uint48 MinSlash;//точность 1e-9

        uint8 OrderEnum;//0-99: 0=Tera, 1=Eth, 2=BSC

    }

    struct TypeGate
    {
        address TokenAddr;
        uint8  WORK_MODE;//0 - pause, 1 - skip, 2 - own mint (from tera), 3 - other token
        uint16  TypeERC;//0 - eth, 20-erc20, 721-erc721, 1155-1155
        uint48 Rate;//курс монеты к eth (в полях Amount и TransferFee) с точностью 1e-9
        uint8 Decimals;
    }

    struct TypeConf
    {
        uint48  WorkNum;
        uint48  HeadOrderID;
        uint48  TailOrderID;
        uint48  NewOrderID;
        //24
    }



    struct TypeNotary
    {
        uint8 Notary;
        address Addr;
        uint8 CanSign;

        uint64 SumDeposit;//депозит Eth с точнсостью до 1e9
    }

    struct TypeSigner
    {
        uint8 Notary;
        bytes32 SignR;
        bytes32 SignS;
        uint8 SignV;
        uint8 Slash;
    }

    struct TypeOrder
    {
        uint32 Gate;
        uint48 ID;
        uint32  AddrTera;
        bytes20 AddrEth;
        bytes TokenID;
        uint64 Amount;//точность до 1e-9
        uint64 TransferFee;////точность до 1e-9
        bytes Description;

        uint8 Process;
        uint64 NotaryFee;//точность до 1e-9

        uint48 PrevID;
        uint48 NextID;

        uint48 BodyID;
        uint16 BodyLength;

        TypeSigner[] SignArr;

    }



}


contract DataLib is TypeLib
{
    address internal Owner;
    TypeCommon internal ConfCommon;
    TypeConf internal ConfData;//TERA->ETH
    //TypeConf internal ConfData2;//ETH->TERA

    //notary
    mapping(uint8 => TypeNotary) internal NotaryList;

    uint internal ExtData;


    //TokenERC20 internal Token;

    mapping(uint32 => TypeGate) internal GateList;




}



contract ConvertLib is DataLib
{
    //------------------------------------------------------------------------
    //------------------------------------------------------------------------


    function toAddress(bytes memory _bytes, uint256 _start) internal pure returns (address) {
        require(_start + 20 >= _start, "toAddress_overflow");
        require(_bytes.length >= _start + 20, "toAddress_outOfBounds");
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function RevertBytes(uint Data)  internal pure returns (uint Ret)
    {
        assembly
        {
            for { let i := 0 } lt(i, 32) { i := add(i, 1) }
            {
                Ret := mul(Ret,0x100)
                Ret := or(Ret,and(Data,0xFF))

                Data := div(Data,0x100)
            }
        }
    }

    function GetAddrFromBytes(bytes memory Addr) internal pure returns (address)
    {
        require(Addr.length >= 20, "GetAddrFromBytes_outOfBounds");

        uint160 addr=0;
        assembly
        {
            addr := div(mload(add(Addr,32)), 0x1000000000000000000000000)
        }

        return address(addr);
    }

    function GetAddrFromBytes20(bytes20 Addr) internal pure returns (address)
    {
        uint160 addr;
        assembly
        {
            addr := div(Addr, 0x1000000000000000000000000)
        }

        return address(addr);
    }


    //------------------------------------------------------------------------
    function MemCpy(uint dest,uint src, uint16 size)  internal pure
    {
        // Copy word-length chunks while possible
        for(; size >= 32; size -= 32)
        {
            assembly
            {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }


        // Copy remaining bytes
        uint mask = 256 ** (32 - size) - 1;
        assembly
        {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    //------------------------------------------------------------------------
    //-------------------------------- TERA decode library for Solidity
    //------------------------------------------------------------------------
    function GetBufPos(bytes memory Buf) pure internal returns (uint Ret)
    {
        assembly
        {
            Ret := add(Buf,32)
        }
    }


    //------------------------------------------------------------------------


    function GetBytes32(uint Data)  internal pure returns (bytes32 RetArr)
    {
        assembly
        {
            RetArr := mload(Data)
        }
    }
    function GetBytes20(uint Data)  internal pure returns (bytes20 RetArr)
    {
        assembly
        {
            RetArr := mload(Data)
            RetArr := and(RetArr, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000)
        }
    }

    function GetBytes10(uint Data)  internal pure returns (bytes10 RetArr)
    {
        assembly
        {
            RetArr := mload(Data)
            RetArr := and(RetArr, 0xFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000)
        }
    }

    function GetBytes(uint Data, uint16 size)  internal pure returns (bytes memory RetArr)
    {
        RetArr=new bytes(size);
        uint dest;
        assembly
        {
            dest := add(RetArr, 0x20)
        }
        MemCpy(dest,Data,size);
    }


    function Bytes32FromBytes(bytes memory Data)  internal pure returns (bytes32 RetArr)
    {
        uint ShrCount;
        if(Data.length<32)
            ShrCount=8*(32-Data.length);

        assembly
        {
            RetArr := mload(add(Data, 0x20))
            RetArr := shr(ShrCount,RetArr)
        }
    }


    function UintFromBytes(bytes memory Data)  internal pure returns (uint RetArr)
    {
        uint ShrCount;
        if(Data.length==0)
            return 0;
        if(Data.length<32)
            ShrCount=8*(32-Data.length);

        assembly
        {
            RetArr := mload(add(Data, 0x20))
            RetArr := shr(ShrCount,RetArr)
        }
    }
    function UintFromBytes10(bytes memory Data)  internal pure returns (uint Ret)
    {
        uint256 value = UintFromBytes(Data);

        uint256 Mult=1;
        while (value != 0)
        {
            uint256 B=value%16;
            require(B<10, "UintFromBytes10: Received a character in the range A-F");

            Ret = Ret + B*Mult;

            Mult = Mult*10;
            value = value >> 4;
        }

    }

    function GetUint1(uint Data) internal pure returns (uint8 Num)
    {
        assembly
        {
            Num := shr(248,mload(Data))
        }
    }

    function GetUint2(uint Data) internal pure returns (uint16 Num)
    {
        assembly
        {
            Num := shr(240,mload(Data))
        }
    }

    function GetUint3(uint Data) internal pure returns (uint24 Num)
    {
        assembly
        {
            Num := shr(232,mload(Data))
        }
    }

    function GetUint4(uint Data) internal pure returns (uint32 Num)
    {
        assembly
        {
            Num := shr(224,mload(Data))
        }
    }
    function GetUint5(uint Data) internal pure returns (uint40 Num)
    {
        assembly
        {
            Num := shr(216,mload(Data))
        }
    }
    function GetUint6(uint Data) internal pure returns (uint48 Num)
    {
        assembly
        {
            Num := shr(208,mload(Data))
        }
    }
    function GetUint8(uint Data) internal pure returns (uint64 Num)
    {
        assembly
        {
            Num := shr(192,mload(Data))
        }
    }







    //------------------------------------------------------------------------
    //-------------------------------- TERA encode library for Solidity
    //------------------------------------------------------------------------

    function EncodeUint(uint Buf,uint256 Value,uint16 size) pure internal
    {
        uint16 rotate=256-size*8;

        assembly
        {
            mstore(Buf, shl(rotate,Value))
        }
    }

    function EncodeArrConst(uint Buf,bytes32 Value) pure internal
    {
        assembly
        {
            mstore(Buf, Value)
        }
    }

    function EncodeBytes(uint Buf,bytes memory Value) pure internal
    {
        uint16 size=uint16(Value.length);

        uint src;
        assembly
        {
            src := add(Value, 0x20)
        }
        MemCpy(Buf,src,size);
    }




    //------------------------------------------------------------------------
    //Order lib
    //------------------------------------------------------------------------

    function CheckBufPos(bytes memory Buf,uint BufPos) pure internal
    {
        uint StartPos;
        assembly
        {
            StartPos := add(Buf,32)
        }
        StartPos+=Buf.length;
        require(StartPos>=BufPos,"Error BufPos");
    }

    //SizeMode: 2-from store,3-from extern tx
    function FillOrderBody(TypeOrder memory Order, bytes memory Buf, uint SizeMode)  internal  pure
    {
        /*
        TERA:
        Order.Gate=DecodeUint(Buf,4);
        Order.ID=DecodeUint(Buf,6);
        Order.AddrTera=DecodeUint(Buf,4);
        Order.AddrEth=GetHexFromArr(DecodeArrConst(Buf,20));
        Order.TokenID=GetHexFromArr(DecodeArr(Buf));
        Order.Amount=DecodeUint(Buf,8)/1e9;
        Order.TransferFee=DecodeUint(Buf,8)/1e9;
        Order.Description=DecodeStr(Buf);
        */

        require(SizeMode>=BUF_STORE,"FillOrderBody:SizeMode error");

        uint MustMinLength=4+6+4+20 +2 +8+8+2;


        if(SizeMode==BUF_EXTERN_FULL)
            MustMinLength+= 1+66;
        if(SizeMode==BUF_STORE)
            MustMinLength+= 1+66 + 8;
        //BUF_EXTERN_HEADER - not add

        require(Buf.length>=MustMinLength,"Error FillOrderBody Data length");

        uint16 size;


        uint BufPos=GetBufPos(Buf);

        Order.Gate=GetUint4(BufPos); BufPos+=4;
        Order.ID=GetUint6(BufPos);   BufPos+=6;


        Order.AddrTera=GetUint4(BufPos); BufPos+=4;
        Order.AddrEth=GetBytes20(BufPos);BufPos+=20;

        size=GetUint2(BufPos);BufPos+=2;
        Order.TokenID=GetBytes(BufPos,size);BufPos+=size;


        Order.Amount=GetUint8(BufPos); BufPos+=8;
        Order.TransferFee=GetUint8(BufPos); BufPos+=8;





        size=GetUint2(BufPos);BufPos+=2;
        Order.Description=GetBytes(BufPos,size);BufPos+=size;

        if(SizeMode==BUF_EXTERN_HEADER)//data from tx AddOrder
        {
            CheckBufPos(Buf,BufPos);
            return;
        }



        size=GetUint1(BufPos); BufPos++;

        if(size>0)
        {
            Order.SignArr=new TypeSigner[](size);
            for(uint8 i=0;i<size;i++)
            {
                TypeSigner memory Item=Order.SignArr[i];

                Item.Notary=GetUint1(BufPos); BufPos++;
                Item.SignR=GetBytes32(BufPos);BufPos+=32;
                Item.SignS=GetBytes32(BufPos);BufPos+=32;
                Item.SignV=GetUint1(BufPos);BufPos++;
            }
        }


        if(SizeMode==BUF_EXTERN_FULL)//data from tx ExecOrder
        {
            CheckBufPos(Buf,BufPos);
            return;
        }

        //data from state
        Order.NotaryFee=GetUint8(BufPos); BufPos+=8;
        CheckBufPos(Buf,BufPos);
    }

    //SizeMode: 1-for sign, 2-for save to store,3-for extern use (get full info)
    function GetBufFromOrder(TypeOrder memory Order,uint SizeMode) pure internal returns (bytes memory)
    {
        /*
        TERA:
        EncodeUint(Buf,Order.Gate,4);
        EncodeUint(Buf,Order.ID,6);
        EncodeUint(Buf,Order.AddrTera,4);
        EncodeArrConst(Buf,Order.AddrEth,20);
        EncodeArr(Buf,Order.TokenID);
        EncodeUint(Buf,FromFloat(Order.Amount),8);
        EncodeUint(Buf,FromFloat(Order.TransferFee),8);
        EncodeStr(Buf,Order.Description);
        */
        require(SizeMode>0,"GetBufFromOrder:SizeMode error");

        uint32 size1=uint32(Order.TokenID.length);
        uint32 size2=uint32(Order.Description.length);
        uint32 size3=uint32(Order.SignArr.length);
        uint Length=4+6+4+20+2+8+8+2+size1+size2;
        if(SizeMode>=BUF_STORE)
            Length+= 1 + size3*66 +  8;// + 1;

        if(SizeMode==BUF_EXTERN_FULL)
            Length+= 1 + 6+6;


        bytes memory Buf=new bytes(Length);

        uint BufPos=GetBufPos(Buf);



        EncodeUint(BufPos,Order.Gate,4);             BufPos+=4;
        EncodeUint(BufPos,Order.ID,6);               BufPos+=6;
        EncodeUint(BufPos,Order.AddrTera,4);         BufPos+=4;
        EncodeArrConst(BufPos,Order.AddrEth);        BufPos+=20;

        EncodeUint(BufPos,size1,2);                  BufPos+=2;
        EncodeBytes(BufPos,Order.TokenID);           BufPos+=size1;


        EncodeUint(BufPos,Order.Amount,8);           BufPos+=8;
        EncodeUint(BufPos,Order.TransferFee,8);      BufPos+=8;

        EncodeUint(BufPos,size2,2);                  BufPos+=2;
        EncodeBytes(BufPos,Order.Description);       BufPos+=size2;

        if(SizeMode==BUF_SIGN)//sign
            return Buf;

        EncodeUint(BufPos,size3,1);                  BufPos++;

        for(uint8 i=0;i<size3;i++)
        {
            TypeSigner memory Item=Order.SignArr[i];

            EncodeUint(BufPos,Item.Notary,1);     BufPos++;
            EncodeArrConst(BufPos,Item.SignR);    BufPos+=32;
            EncodeArrConst(BufPos,Item.SignS);    BufPos+=32;
            EncodeUint(BufPos,Item.SignV,1);      BufPos++;
        }


        EncodeUint(BufPos,Order.NotaryFee,8);     BufPos+=8;
        //        EncodeUint(BufPos,Order.Process,1);       BufPos++;

        if(SizeMode==BUF_STORE)//store
        {
            CheckBufPos(Buf,BufPos);
            return Buf;
        }

        //full
        EncodeUint(BufPos,Order.Process,1);        BufPos++;

        EncodeUint(BufPos,Order.PrevID,6);         BufPos+=6;
        EncodeUint(BufPos,Order.NextID,6);         BufPos+=6;

        CheckBufPos(Buf,BufPos);
        return Buf;

    }



    function GetSignBufFromOrder(TypeOrder memory Order)  pure internal returns (bytes memory Buf)
    {
        Buf=GetBufFromOrder(Order,1);
    }


}




//серилизация/десерилизация с хранилищем

contract StorageLib is DataLib, ConvertLib
{




    //------------------------------------------------------------------------ Order slots

    function SaveHeaderBytes(uint ID,uint HeaderData)internal
    {
        uint PosHeader=(0xABCE<<240) | (ID<<192);

        // solhint-disable-next-line no-inline-assembly
        assembly
        {
            sstore(PosHeader, HeaderData)
        }
    }

    function LoadHeaderBytes(uint ID)internal view returns (uint HeaderData)
    {
        uint PosHeader=(0xABCE<<240) | (ID<<192);
        // solhint-disable-next-line no-inline-assembly
        assembly
        {
            HeaderData := sload(PosHeader)
        }
    }


    function SaveBodyBytes(uint BodyID,bytes memory data)internal
    {

        uint PosBody = (0xABCE<<240) | (BodyID<<192) | 1;
        uint PosData;
        assembly
        {
            PosData := add(data,32)
        }
        int Counter=int(data.length);
        while(Counter>0)
        {
            // solhint-disable-next-line no-inline-assembly
            assembly
            {
                sstore(PosBody, mload(PosData))
            }


            PosBody+=32;
            PosData+=32;
            Counter-=32;
        }
    }

    function LoadBodyBytes(uint BodyID,uint Length)internal view returns (bytes memory)
    {

        uint PosBody = (0xABCE<<240) | (BodyID<<192) | 1;
        bytes memory Buf=new bytes(Length);
        uint PosData;
        assembly
        {
            PosData := add(Buf,32)
        }

        int Counter=int(Length);
        while(Counter>0)
        {
            assembly
            {
                mstore(PosData, sload(PosBody))
            }


            PosBody+=32;
            PosData+=32;
            Counter-=32;
        }



        return Buf;
    }



}




contract OwnerLib is StorageLib
{

    modifier OnlyOwner()
    {
        require(msg.sender == Owner,"Need only owner access!!");
        _;
    }


    function SetOwner(address newOwner) public OnlyOwner
    {
        if (newOwner != address(0))
        {
            Owner = newOwner;
        }
    }

}


contract NotaryLib is OwnerLib
{
    //------------------------------------------------------------------------ Notary

    function SetNotary(uint8 Notary,bytes memory Addr,uint64 Deposit, uint8 CanSign) public OnlyOwner       //<------------------ owner
    {

        require(Notary<=ConfCommon.NOTARY_COUNT, "Notary num cannot more NotaryCount");

        if(Notary==ConfCommon.NOTARY_COUNT)
            ConfCommon.NOTARY_COUNT++;

        NotaryList[Notary]=TypeNotary({Notary:Notary,Addr:GetAddrFromBytes(Addr),CanSign:CanSign, SumDeposit:Deposit});

    }

    function DeleteLastNotary() public OnlyOwner                                                            //<------------------ owner
    {

        require(ConfCommon.NOTARY_COUNT>0, "No Notary");

        ConfCommon.NOTARY_COUNT--;
        delete NotaryList[ConfCommon.NOTARY_COUNT];


    }

    function GetNotary(uint8 Num)public view returns(TypeNotary memory)
    {
        return NotaryList[Num];
    }


}


contract OrderLib is OwnerLib
{
    //------------------------------------------------------------------------ Time


    function OrderInPeriod(uint ID) view internal returns(uint)
    {
        uint BlockNumOrder=ID/100000;

        uint TimeStampOrder=ConfCommon.FIRST_TIME_BLOCK + BlockNumOrder * ConfCommon.CONSENSUS_PERIOD_TIME;
        if(block.timestamp<TimeStampOrder)
            return 1;

        uint KMult=ConfCommon.CONSENSUS_PERIOD_TIME;

        if(block.timestamp>TimeStampOrder+ConfCommon.MAX_TRANSFER_PERIOD*KMult)
            return 4;

        if(block.timestamp>TimeStampOrder+ConfCommon.MAX_SIGN_PERIOD*KMult)
            return 3;

        return 2;
    }






    //------------------------------------------------------------------------ Sign

    function CheckOrderSign(TypeOrder memory Order) internal view returns (bool)
    {
        //TypeConf memory Conf=LoadConf();

        uint8[] memory WasNotary=new uint8[](256);
        bytes32 Hash=GetSignOrderHash(Order);

        uint8 CountSign=0;
        for(uint8 i=0;i<Order.SignArr.length;i++)
        {
            TypeSigner memory Item=Order.SignArr[i];
            if(WasNotary[Item.Notary]==1)
                continue;

            require(Item.Notary<ConfCommon.NOTARY_COUNT,"Error notary num");


            TypeNotary memory ItemNotary=NotaryList[Item.Notary];
            require(ItemNotary.Addr!=address(0),"Error notary addr");



            //LogBuf=GetSignBufFromOrder(Order);

            address AddrFromSign=ecrecover(Hash, Item.SignV, Item.SignR, Item.SignS);

            if(ItemNotary.Addr==AddrFromSign)
            {
                CountSign++;
                if(CountSign>=ConfCommon.MIN_SIGN_COUNT)
                    return true;
            }
            WasNotary[Item.Notary]=1;
        }

        require(CountSign>=ConfCommon.MIN_SIGN_COUNT,"Error multisign count");



        return true;
    }




    function GetSignOrderHash(TypeOrder memory Order)  pure internal returns (bytes32)
    {
        bytes memory Buf=GetSignBufFromOrder(Order);
        //return sha256(Buf);
        return keccak256(Buf);
    }



    //------------------------------------------------------------------------


    function GetOrderHeader(uint48 ID) public view returns(bytes32)
    {
        uint Header=LoadHeaderBytes(ID);
        return bytes32(Header);
    }
    function GetBody(uint48 BodyID,uint Length) public view returns(bytes memory)
    {
        return LoadBodyBytes(BodyID,Length);
    }
    function GetOrderObject(uint48 ID) public view returns(TypeOrder memory)
    {
        return LoadOrder(ID);
    }





    //----------------------------------------------------------------------------------------------- SAVE/LOAD ORDER
    function SaveOrderHeader(TypeOrder memory Order)internal
    {
        uint FData=(uint(Order.BodyLength)<<240) | (uint(Order.PrevID)<<192) | (uint(Order.NextID)<<144) | (uint(Order.BodyID)<<96)  | (uint(Order.Process)<<88);
        SaveHeaderBytes(Order.ID,FData);
    }
    function FillOrderHeader(TypeOrder memory Order,uint FData)internal pure
    {
        Order.BodyLength = uint16((FData>>240) & 0xFFFFFFFFFFFF);
        Order.PrevID     = uint48((FData>>192) & 0xFFFFFFFFFFFF);
        Order.NextID     = uint48((FData>>144) & 0xFFFFFFFFFFFF);
        Order.BodyID     = uint48((FData>>96) & 0xFFFFFFFFFFFF);
        Order.Process    = uint8((FData>>88) & 0xFF);
    }

    function LoadOrder(uint48 ID) internal view returns(TypeOrder memory)
    {
        TypeOrder memory Order;
        uint FData=LoadHeaderBytes(ID);

        FillOrderHeader(Order,FData);
        if(Order.BodyID==0)
            return Order;

        Order.ID=ID;
        bytes memory Buf=LoadBodyBytes(Order.BodyID,Order.BodyLength);
        FillOrderBody(Order,Buf,BUF_STORE);



        return Order;
    }

    function GetOrder(uint48 ID) public view returns(bytes memory)
    {

        TypeOrder memory Order=LoadOrder(ID);
        if(Order.ID==0)
            return "";
        return GetBufFromOrder(Order,BUF_EXTERN_FULL);
    }

    function GetOrderList(uint48 ID, uint16 Count) public view returns(bytes[] memory Arr)
    {
        TypeOrder memory Order;
        Arr=new bytes[](Count);
        uint32 Num=0;
        uint48 NextID=ID;
        while(NextID>0)
        {
            Order=LoadOrder(NextID);
            if(Order.ID==0)
                break;
            Arr[Num]=GetBufFromOrder(Order,BUF_EXTERN_FULL);
            NextID=Order.NextID;

            Num++;
            if(Num>=Count)
                break;
        }
    }


    function SaveOrder(TypeOrder memory Order)internal
    {
        require(Order.BodyID>0, "Error Order.BodyID");



        bytes memory Buf=GetBufFromOrder(Order,BUF_STORE);
        Order.BodyLength=uint16(Buf.length);

        SaveOrderHeader(Order);
        SaveBodyBytes(Order.BodyID,Buf);
    }

    function SaveNewOrder(TypeConf storage Conf,TypeOrder memory Order,uint8 CheckUnique)internal
    {
        require(Order.ID>0,"Error order ID");
        require(Order.Amount<=1e21,"Amount more then 1e21");
        require(Order.TransferFee<=1e21,"TransferFee more then 1e21");

        if(CheckUnique>0)
        {
            uint Header=LoadHeaderBytes(Order.ID);
            require(Header==0,"Order was payed");
        }

        Order.BodyID=Order.ID;

        //используем BodyID последнего ордера в удаляемом периоде
        if(Conf.TailOrderID>0)
        {
            uint Period=OrderInPeriod(Conf.TailOrderID);
            if(Period>=4)
            {
                uint HeaderLast=LoadHeaderBytes(Conf.TailOrderID);

                require(HeaderLast>0,"Error read HeaderLast");

                if(HeaderLast>0)
                {
                    SaveHeaderBytes(Conf.TailOrderID,0);//удаляем его
                    if(Conf.HeadOrderID==Conf.TailOrderID)
                        Conf.HeadOrderID=0;

                    Order.BodyID=uint48((HeaderLast>>96) & 0xFFFFFFFFFFFF);//BodyID
                    Conf.TailOrderID=uint48((HeaderLast>>192) & 0xFFFFFFFFFFFF);//PrevID
                }
            }
        }


        Order.NextID=Conf.HeadOrderID;
        SaveOrder(Order);


        //записываем ссылку на этот ордер в предыдущем ордере
        if(Conf.HeadOrderID>0)
        {
            uint HeaderFirst=LoadHeaderBytes(Conf.HeadOrderID);
            require(HeaderFirst>0,"Error read HeadOrderID");


            //новая ссылка
            HeaderFirst = HeaderFirst |  (uint(Order.ID) << 192);

            SaveHeaderBytes(Conf.HeadOrderID,HeaderFirst);
        }

        Conf.HeadOrderID=Order.ID;
        if(Conf.TailOrderID==0)
            Conf.TailOrderID=Order.ID;


    }



}


interface IOwnTokenERC
{
    function SetSmart(address newOwner) external;
    function SmartMint(address account, uint256 id, uint Amount) external;
    function SmartBurn(address account, uint256 id, uint Amount) external;
}

contract BridgeERC20 is OwnerLib
{


    function SendOrMint(TypeGate memory Gate, address AddrEth, bytes memory OrderTokenID, uint256 Amount) internal
    {
        uint TokenID=GetTokenID(OrderTokenID);

        if(Gate.WORK_MODE==ERC_MINT)
        {
            IOwnTokenERC(Gate.TokenAddr).SmartMint(AddrEth, TokenID, Amount);
        }
        else//ERC_OTHER
        {
            if(Gate.TypeERC==0)//eth
            {
                payable(AddrEth).transfer(Amount);
            }
            else
                if(Gate.TypeERC==20)
                {
                    IERC20(Gate.TokenAddr).transfer(AddrEth, Amount);
                }
                else
                    if(Gate.TypeERC==721)
                    {
                        IERC721(Gate.TokenAddr).safeTransferFrom(address(this), AddrEth, TokenID);
                        //IERC721(Gate.TokenAddr).transferFrom(address(this), AddrEth, TokenID);
                    }
                    else
                        if(Gate.TypeERC==1155)
                        {
                            IERC1155(Gate.TokenAddr).safeTransferFrom(address(this), AddrEth, TokenID, Amount, "");
                        }

        }
    }


    function ReceiveOrBurn(TypeGate memory Gate, address AddrEth, bytes memory OrderTokenID, uint256 Amount) internal
    {
        uint TokenID=GetTokenID(OrderTokenID);

        if(Gate.WORK_MODE==ERC_MINT)
        {
            IOwnTokenERC(Gate.TokenAddr).SmartBurn(AddrEth, TokenID, Amount);
        }
        else//ERC_OTHER
        {
            if(Gate.TypeERC==0)//eth
            {
                require(uint64(msg.value) >= Amount,"Error receive Amount");
            }
            else
                if(Gate.TypeERC==20)
                {
                    //надо ли проверять IERC20.allowance() ??
                    IERC20(Gate.TokenAddr).transferFrom(msg.sender, address(this), Amount);
                }
                else
                    if(Gate.TypeERC==721)
                    {
                        IERC721(Gate.TokenAddr).transferFrom(msg.sender, address(this), TokenID);
                    }
                    else
                        if(Gate.TypeERC==1155)
                        {
                            IERC1155(Gate.TokenAddr).safeTransferFrom(msg.sender, address(this), TokenID, Amount, "");
                        }

        }
    }

    function GetTokenID(bytes memory Data)  internal pure returns (uint TokenID)
    {
        if(Data.length<32)
            TokenID=UintFromBytes10(Data);
        else
            TokenID=UintFromBytes(Data);
    }


    //------------------------------------------------------------------------ Gate

    function GetGate(uint32 Num) public view returns(TypeGate memory)
    {
        return GateList[Num];
    }

    function SetGate(uint32 Num, TypeGate memory Gate) public OnlyOwner               //<------------------ owner
    {
        GateList[Num]=Gate;

        if(Gate.WORK_MODE==ERC_MINT)
            IOwnTokenERC(Gate.TokenAddr).SetSmart(address(this));

    }



}



/**
 * @title Bridge
 * @dev Bridge TERA-ETH
 */


contract Bridge is  OrderLib, BridgeERC20, NotaryLib
{
    bytes32 constant ZeroSign32=hex"00112233445566778899aabbccddeeffff112233445566778899aabbccddeeff";




    //------------------------------------------------------------------------ETH->TERA
    function AddOrder(bytes memory Buf)  public payable
    {
        require(ConfCommon.WORK_MODE>0,"Pausing");
        require(Buf.length<=1024,"Error order buf size");

        TypeOrder memory Order;
        FillOrderBody(Order,Buf,BUF_EXTERN_HEADER);

        address AddrEth=GetAddrFromBytes20(Order.AddrEth);

        TypeGate memory Gate=GateList[Order.Gate];
        require(Gate.WORK_MODE>0,"Error order channel or work mode");

        require(Order.AddrTera>0,"Error AddrTera");
        require(AddrEth==msg.sender,"Error AddrEth");



        //расчет номера ордера внутри блока
        uint OrderNum=0;
        uint BlockNum=(block.timestamp-ConfCommon.FIRST_TIME_BLOCK)/ConfCommon.CONSENSUS_PERIOD_TIME;

        uint PrevBlockNum=ConfData.NewOrderID/100000;
        if(PrevBlockNum>=BlockNum)
            OrderNum = (ConfData.NewOrderID%1000) + 1;

        require(OrderNum<1000,"Big tx num, try later");

        Order.ID=uint48(BlockNum*100000 + ConfCommon.OrderEnum*1000 + OrderNum);
        ConfData.NewOrderID=Order.ID;




        uint256 Amount=uint256(Order.Amount);

        if(Gate.TypeERC==721)
        {
            //комиссия в газе и всегда равна MinNotaryFee
            Order.NotaryFee=ConfCommon.MinNotaryFee;

            //не учитываем в Amount комиссию - ее получили газом
            //переводим точность комиссии к точности 1e18
            uint256 Fee=uint256(Order.NotaryFee+Order.TransferFee)*1e9;//9 - > 18
            require(uint64(msg.value) >= Fee,"Error receive Fee");

        }
        else
        {
            Order.NotaryFee=uint64(uint(ConfCommon.NotaryFee)*(Order.Amount+Order.TransferFee)/1e9);

            //перевод MinNotaryFee в валюту ордера
            uint MinNotaryFee=uint(Gate.Rate)*ConfCommon.MinNotaryFee/1e9;
            if(Order.NotaryFee<MinNotaryFee)
                Order.NotaryFee=uint64(MinNotaryFee);

            Amount += uint256(Order.TransferFee + Order.NotaryFee);
        }


        //переводим точность к точности монеты
        Amount = Amount*(10**Gate.Decimals)/1e9;

        //transfer
        if(Gate.WORK_MODE>ERC_SKIP)
        {
            ReceiveOrBurn(Gate, AddrEth, Order.TokenID, Amount);
        }

        ConfData.WorkNum++;


        //fill notary tx
        CreateEmptyOrderBody(Order);

        //save
        SaveNewOrder(ConfData,Order,0);
    }

    function CreateEmptyOrderBody(TypeOrder memory Order)internal view
    {
        Order.SignArr=new TypeSigner[](ConfCommon.NOTARY_COUNT);
        for(uint8 i=0;i<ConfCommon.NOTARY_COUNT;i++)
        {
            TypeSigner memory Item=Order.SignArr[i];
            Item.Notary=0xFF;
            Item.SignR=ZeroSign32;
            Item.SignS=ZeroSign32;
            Item.SignV=0xFF;
        }
    }


    function NotarySign(uint48 ID, uint8 Notary, bytes32 SignR,bytes32 SignS,uint8 SignV)  public
    {

        //1.Проверяем параметры, что ордер не устарел (SignPeriod)
        //2.Проверка разрешения вызова - нотариус в списке подписантов
        //3.Проверяем что у валидатора есть минимальный депозит (SumDeposit/MinDeposit)
        //4.Проверяем что этот валидатор еще не подписывал
        //5.Проверяем подпись
        //6.Добавляем в массив подписей
        //7.Если достаточное число подписей - ставим признак Process=1
        //8.Записываем признак апдейта в канал

        require(ID>0 && (ID/1000)%100 == ConfCommon.OrderEnum,"The order was not created in this blockchain");

        //1
        uint Period=OrderInPeriod(ID);
        require(Period==2,"Error order period (time stamp)");

        TypeOrder memory Order=LoadOrder(ID);
        require(Order.ID>0,"Error order ID");

        //2
        TypeNotary memory ItemNotary=NotaryList[Notary];
        require(ItemNotary.Addr!=address(0),"Error notary Addr");

        //3
        require(ItemNotary.SumDeposit>=ConfCommon.MinDeposit,"Error notary Deposit");

        bytes32 Hash=GetSignOrderHash(Order);

        uint Was=0;
        uint SignCount=0;
        for(uint8 i=0;i<Order.SignArr.length;i++)
        {
            TypeSigner memory Item=Order.SignArr[i];
            if(Item.Notary!=0xFF)
            {
                //4
                require(Item.Notary!=Notary,"Error was sign Notary");
                SignCount++;
            }
            else
            {
                //5
                address AddrFromSign=ecrecover(Hash, SignV, SignR, SignS);
                require(ItemNotary.Addr==AddrFromSign,"Error Sign");
                //6
                Item.Notary=Notary;
                Item.SignR=SignR;
                Item.SignS=SignS;
                Item.SignV=SignV;

                SignCount++;
                Was=1;
            }
        }

        require(Was==1,"Error search sign slot");

        //7
        if(SignCount==ConfCommon.MIN_SIGN_COUNT)
            Order.Process=1;

        //Если Order.Process==1 и есть NotaryFee, то одинаковыми частями начисляем награду валидаторам - в массив NotaryList.SumDeposit

        //8
        ConfData.WorkNum++;

        SaveOrder(Order);

        //Send gas to notary
    }

    function SlashProof(bytes memory Buf, uint8 Notary, bytes32 SignR,bytes32 SignS,uint8 SignV) public
    {
        //1.Проверяем валидность ID (только ордера созданные в этом блокчейне)
        //2.Проверяем валидность канала
        //3.Проверяем валидность номера нотариуса
        //4.Проверяем что время ордера в периоде = 3 (больше SignPeriod, но меньше TransferPeriod)
        //5.Проверяем подпись
        //6.Проверяем что такой подписи в ордере нет
        //7.
        //8.Добавляем подпись в ордер для предотвращения дальнейших штрафов с такой подписью и ставим Slash=1
        //9.Устанавливаем в ордере NotaryFee = 0
        //10.Штрафуем валидаторов (списанием с депозита), за основу берем большую сумму между полученным ордером и записанным в БД (так как может быть ситуация когда пришедший ID - "левый")
        //11.Записываем признак апдейта в канал

        TypeOrder memory Order;
        FillOrderBody(Order,Buf,BUF_EXTERN_HEADER);

        //1
        require(Order.ID>0 && (Order.ID/1000)%100 == ConfCommon.OrderEnum,"The order was not created in this blockchain");


        //2
        TypeGate memory Gate=GateList[Order.Gate];
        require(Gate.WORK_MODE>0,"Error order channel or work mode");

        //3
        TypeNotary storage ItemNotary=NotaryList[Notary];
        require(ItemNotary.Addr!=address(0),"Error notary Addr");

        //4
        uint Period=OrderInPeriod(Order.ID);
        require(Period==3,"Error order period (time stamp)");


        //5
        bytes32 Hash=GetSignOrderHash(Order);
        address AddrFromSign=ecrecover(Hash, SignV, SignR, SignS);
        require(ItemNotary.Addr==AddrFromSign,"Error Sign");

        //6
        uint8 NewOrder;
        uint8 ItemNum;
        TypeOrder memory OrderDB=LoadOrder(Order.ID);

        //точность 1e9
        uint SlashAmount=Order.Amount + Order.TransferFee;

        if(OrderDB.ID==0)
        {
            NewOrder=1;

            CreateEmptyOrderBody(Order);
        }
        else
        {
            uint SlashAmountDB=OrderDB.Amount + OrderDB.TransferFee;
            if(SlashAmountDB>SlashAmount)
                SlashAmount=SlashAmountDB;

            Order=OrderDB;
        }


        for(uint8 i=0;i<Order.SignArr.length;i++)
        {
            TypeSigner memory Item=Order.SignArr[i];
            //require(Item.Notary!=Notary,"This notary sign was already there"); - так низзя
            require(Item.SignV!=SignV && Item.SignR!=SignR,"This signature was already there");//именно этот вариант, так как это еще неявная проверка одинаковости ордеров

            if(Item.Notary==0xFF)
            {
                ItemNum=i;
                break;
            }
        }




        Order.Process=200;

        //8
        Order.SignArr[ItemNum]=TypeSigner({Notary:Notary,SignR:SignR, SignS:SignS, SignV:SignV, Slash:1});

        //9
        Order.NotaryFee=0;

        if(NewOrder>0)
            SaveNewOrder(ConfData,Order,0);
        else
            SaveOrder(Order);


        //10
        //перевод валюты ордера в Eth
        uint SlashSum=uint(ConfCommon.SlashRate)*SlashAmount*1e9/uint(Gate.Rate);
        if(Gate.TypeERC==721 || SlashSum<ConfCommon.MinSlash)
            SlashSum=ConfCommon.MinSlash;


        //отнимаем из депозита
        if(SlashSum>=ItemNotary.SumDeposit)
        {
            ItemNotary.SumDeposit=0;
        }
        else
        {
            ItemNotary.SumDeposit-=uint64(SlashSum);
        }

        if(ItemNotary.SumDeposit<ConfCommon.MinDeposit)
            ItemNotary.CanSign=0;

        //11
        ConfData.WorkNum++;
    }


    function CancelOrder(uint48 ID) public
    {
        //1. Проверяем время ордера больше SignPeriod
        //2. Проверяем что Process===0
        //3. Устанавливаем в ордере признак обработанности Process=100
        //4. Возвращаем средства
        //5.Записываем признак апдейта в канал

        require(ID>0 && (ID/1000)%100 == ConfCommon.OrderEnum,"The order was not created in this blockchain");


        //1
        uint Period=OrderInPeriod(ID);
        require(Period==3,"Error order period (time stamp)");

        TypeOrder memory Order=LoadOrder(ID);
        require(Order.ID>0,"Error order ID");

        TypeGate memory Gate=GateList[Order.Gate];
        require(Gate.WORK_MODE>0,"Error order channel or work mode");

        //2
        require(Order.Process==0,"The order has already been processed");

        //3
        Order.Process=100;
        SaveOrderHeader(Order);
        //Not Reentrancy


        //4
        //transfer
        address AddrEth=GetAddrFromBytes20(Order.AddrEth);

        if(Gate.WORK_MODE>ERC_SKIP)
        {
            uint256 Amount=uint256(Order.Amount);

            if(Gate.TypeERC==721)
            {
                uint256 Fee=uint256(Order.TransferFee + Order.NotaryFee)*1e9;//9 - > 18
                if(Fee>0)
                {
                    payable(AddrEth).transfer(Fee);
                }
            }
            else
            {
                Amount += uint256(Order.TransferFee + Order.NotaryFee);
            }

            //переводим точность к точности монеты
            Amount = Amount*(10**Gate.Decimals)/1e9;

            SendOrMint(Gate, AddrEth, Order.TokenID, Amount);
        }


        //5
        ConfData.WorkNum++;

    }




    //------------------------------------------------------------------------TERA->ETH
    function ExecOrder(bytes memory Buf)  public
    {


        require(ConfCommon.WORK_MODE>0,"Pausing");
        require(Buf.length<=1024,"Error order buf size");

        TypeOrder memory Order;
        FillOrderBody(Order,Buf,BUF_EXTERN_FULL);

        TypeGate memory Gate=GateList[Order.Gate];
        require(Gate.WORK_MODE>0,"Error order channel or work mode");
        require(Order.ID>0,"Error order ID");
        //require(Order.ID%2==1,"Error order ID");
        require((Order.ID/1000)%100 == 0,"The order was not created in Tera-Hub");

        uint Period=OrderInPeriod(Order.ID);
        require(Period>=2 && Period<=3,"Error order period (time stamp)");


        //signs
        CheckOrderSign(Order);

        Order.Process=1;



        //Save order
        SaveNewOrder(ConfData,Order,1);//запись с обязательной проверкой уникальности ID
        //Not Reentrancy

        //transfer
        if(Gate.WORK_MODE>ERC_SKIP)
        {
            address AddrEth=GetAddrFromBytes20(Order.AddrEth);

            uint256 Amount=uint256(Order.Amount);

            if(Order.TransferFee>0)
            {
                uint256 Fee=uint256(Order.TransferFee);

                if(Gate.TypeERC==721)
                {
                    //возврат газа?? но там были Тера
                    //payable(AddrEth).transfer(Fee*1e9);//9 - > 18
                }
                else
                    if(tx.origin==AddrEth)
                    {
                        Amount+=Fee;
                    }
                    else
                    {
                        //переводим точность к точности монеты
                        Fee = Fee*(10**Gate.Decimals)/1e9;

                        SendOrMint(Gate, tx.origin, "", Fee);
                    }
            }

            //переводим точность к точности монеты
            Amount = Amount*(10**Gate.Decimals)/1e9;

            SendOrMint(Gate, AddrEth, Order.TokenID, Amount);

        }

        ConfData.WorkNum++;

    }



    //------------------------------------------------------------------------ COMMON
    function SetCommon(TypeCommon memory Conf) public OnlyOwner                         //<------------------ owner
    {
        ConfCommon=Conf;
    }



    function GetCommon() public view returns(TypeCommon memory)                         //<------------------ owner
    {
        return ConfCommon;
    }


    function GetConf() public view returns(TypeConf memory)
    {
        return ConfData;
    }



}


