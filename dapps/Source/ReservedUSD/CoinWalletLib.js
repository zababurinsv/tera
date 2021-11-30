//Smart-contract: CoinWalletLib


function OnGet()//getting coins
{
    DoGet();
}


"public"
function DoGet()
{
    if(context.SmartMode)
        return;

    //проверка на спец. счета
    var KeyAcc="ACC:"+context.Account.Num;
    var bBaseAcc;
    if(context.Account.Num===context.Smart.Account)
        bBaseAcc=1;
    else
        bBaseAcc=ReadValue(KeyAcc,"byte");
    if(!bBaseAcc)
        return 0;


    var ObjWallet=GetObjWallet(context.FromNum,context.FromNum);
    if(ObjWallet.AccWallet!==context.Account.Num)
        throw "Error current Account = "+context.Account.Num+" need = "+ObjWallet.AccWallet;



    if(!ISZERO(context.Value))//deposit
    {
        if(context.Description!=="init")
            Deposit(ObjWallet);

        return 1;
    }
    else
    if(context.Description)//withdraw
    {
        Withdraw(ObjWallet);
        return 1;

    }
    else
    {
        var Amount=FLOAT_FROM_COIN(ReadCoin(ObjWallet));
        Event("Amount: "+Amount);
        return 0;
    }
}


function GetObjWallet(OwnerNum,ToNum)
{
    var AccObj=ReadAccount(ToNum);
    var AccWallet;
    if(!AccObj.Currency)
    {
        AccWallet=context.Smart.Account;
    }
    else
    {
        var Key="CUR:"+AccObj.Currency;
        var Value=ReadValue(Key,GetFormatCurrency());
        if(!Value)
            throw "Not was set Wallet Account for currency: "+AccObj.Currency;

        AccWallet=Value.Account;
    }

    var AccFromObj;
    if(OwnerNum===ToNum)
        AccFromObj=AccObj;
    else
        AccFromObj=ReadAccount(OwnerNum);


    return {PubKeyStr:AccFromObj.PubKeyStr, Currency:AccObj.Currency, AccWallet:AccWallet};
}


function Deposit(AccObj)
{
    //throw "Cannt deposit";
    AddCoin(AccObj,context.Value);
}

function Withdraw(ObjWallet)
{
    WithdrawSum(context.FromNum,parseFloat(context.Description),ObjWallet);
}

"public"
function DepositSum(FromNum,fSum)
{
    //throw "Cannt deposit";
    if(fSum<1e-9)
        return;

    var ObjWallet=GetObjWallet(FromNum,FromNum);
    var CurAmount=COIN_FROM_FLOAT2(fSum);

    Move(FromNum,ObjWallet.AccWallet,CurAmount,"Deposit");
    AddCoin(ObjWallet,CurAmount);
}


"public"
function WithdrawSum(ToNum,fSum,ObjWallet)
{
    // if(context.BlockNum<69900000)
    //     throw "Withdraw freeze, wait "+(69900000-context.BlockNum)+" blocks";
    //throw "Cannt withdraw";

    if(fSum<1e-9)
        return;

    if(!ObjWallet)
        ObjWallet=GetObjWallet(context.FromNum,ToNum);

    var CurAmount=COIN_FROM_FLOAT2(fSum);
    SubCoin(ObjWallet,CurAmount);

    Move(ObjWallet.AccWallet,ToNum,CurAmount,"Withdraw");
}



function GetFormatCurrency()
{
    return {Account:"uint"};
}




//processing
function COIN_FROM_FLOAT2(Sum)
{
    var MAX_SUM_CENT = 1e9;
    var SumCOIN=Math.floor(Sum);
    var SumCENT = Math.floor(Sum * MAX_SUM_CENT - SumCOIN * MAX_SUM_CENT);
    var Coin={SumCOIN:SumCOIN,SumCENT:SumCENT};
    return Coin;
}

"public"
function GetKey(AccObj)
{
    return "AMOUNT:"+AccObj.PubKeyStr+":"+AccObj.Currency;
}


"public"
function GetFormatCoin()
{
    return {SumCOIN:"uint", SumCENT:"uint32", Flag:"uint", Freeze:{Sum:"double", Block:"uint32", Finish:"uint32"}};
}

"public"
function ReadCoin(AccObj)
{
    var KeyAmount=GetKey(AccObj);
    var AmountWas=ReadValue(KeyAmount,GetFormatCoin());
    if(!AmountWas)
    {
        AmountWas={SumCOIN:0, SumCENT:0,Flag:0,Freeze:{Sum:0, Block:0, Finish:0}};
        //if(AccObj.Currency===0) AmountWas.SumCOIN=100000;
    }

    return AmountWas;
}


"public"
function AddCoin(AccObj,Value)
{
    var KeyAmount=GetKey(AccObj);
    var AmountWas=ReadCoin(AccObj);
    ADD(AmountWas,Value);
    WriteValue(KeyAmount,AmountWas,GetFormatCoin());
}

"public"
function AddSumFreeze(AccObj,Sum,FreezeTime)
{
    var KeyAmount=GetKey(AccObj);
    var AmountWas=ReadCoin(AccObj);

    var Value=COIN_FROM_FLOAT2(Sum);
    ADD(AmountWas,Value);

    DoFreeze(AmountWas.Freeze)
    AddFreeze(AmountWas.Freeze,Sum,FreezeTime);


    WriteValue(KeyAmount,AmountWas,GetFormatCoin());
}


"public"
function SubCoin(AccObj,Value)
{
    var KeyAmount=GetKey(AccObj);
    var AmountWas=ReadCoin(AccObj);
    DoFreeze(AmountWas.Freeze);

    var WasFloat=FLOAT_FROM_COIN(AmountWas)-AmountWas.Freeze.Sum;
    var fValue=FLOAT_FROM_COIN(Value);


    if(WasFloat<fValue || !SUB(AmountWas,Value))
        throw "Error current amount = "+fValue+" Free amount = "+WasFloat;


    WriteValue(KeyAmount,AmountWas,GetFormatCoin());
}


//for static call

"public"
function GetKeyValue(Params)
{
    return ReadValue(Params.Key,Params.Format);
}



"public"
function SetWalletAccount(Params)
{
    var AccObj=ReadAccount(Params.Account);
    if(AccObj.Value.Smart!==context.Smart.Num)
        throw "Account "+Params.Account+" must have smart = "+context.Smart.Num;

    if(!AccObj.Currency)
        throw "Account "+Params.Account+" must have currency";


    var SmartObj=ReadSmart(AccObj.Currency);
    if(!SmartObj)
        throw "Account must have valid currency";


    if(AccObj.PubKey[0]!==0)//check nobody access to account
        throw "Account must have zero public key";

    var Key="CUR:"+AccObj.Currency;
    var Value=ReadValue(Key,GetFormatCurrency());
    if(Value)
        throw "Account was set = "+JSON.stringify(Value);


    WriteValue(Key,Params,GetFormatCurrency());


    var KeyAcc="ACC:"+AccObj.Num;
    WriteValue(KeyAcc,1,"byte");

    Params.cmd="Set";
    Event(Params);
}





//freeze-lib
function AddFreeze(Item,AddSum,FreezeTime)
{
    var S=Item.Sum+AddSum;
    if(!AddSum || S<1e-9)
        return;

    var T1=Item.Finish-Item.Block;
    var T=(Item.Sum*T1 + AddSum*FreezeTime)/S;


    Item.Sum=S;
    Item.Block=context.BlockNum;
    Item.Finish=Item.Block+Math.floor(T);

}

function DoFreeze(Item)
{
    var CurBlockNum=context.BlockNum;

    var T=Item.Finish-Item.Block;
    if(T<=0)
    {
        Item.Sum=0;
        Item.Block=0;
        return;
    }
    else
    {
        var dS=Item.Sum/T;
        Item.Sum-=dS*(CurBlockNum-Item.Block);
        if(Item.Sum<1e-9)
            Item.Sum=0;
    }

    Item.Block=CurBlockNum;
}

