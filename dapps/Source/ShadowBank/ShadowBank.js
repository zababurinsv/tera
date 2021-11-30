//{Open:byte,MinAmount:uint32,Fee:uint32,Profit:uint32, DepositBlock:uint,DepositTr:uint16,OrderBlock:uint,OrderTr:uint16,DepositCompleted:uint,OrderCompleted:uint,BalanceVer:uint,BalanceBlock:uint,BalanceTr:uint16,Atom:uint, HTMLBlock:uint,HTMLTr:uint16}

/*
{
Open:byte,
MinAmount:uint32,
Fee:uint32,

Profit:uint32,

DepositBlock:uint,
DepositTr:uint16,

OrderBlock:uint,
OrderTr:uint16,

DepositCompleted:uint,
OrderCompleted:uint,

BalanceVer:uint,
BalanceBlock:uint,
BalanceTr:uint16,

Atom:uint,

HTMLBlock:uint,HTMLTr:uint16}

*/
//74


function GetLib()
{
    return require(8);//List-lib
}

function CheckPermission()
{
    if(context.Account.Num!==context.FromNum)
        throw "Access is allowed only from your own account.";
}
function CheckPermissionBase()
{
    if(context.Smart.Account!==context.FromNum)
        throw "Access is allowed only from base account.";
}




function OnGet()
{
    var lib=GetLib();
    if(lib.OnGet())
        return;

    //Profit field
    var BaseNum=context.Smart.Account;
    if(context.Account.Num===BaseNum && context.Value.SumCOIN && context.Description!=="Deposit")
    {
        var State=ReadState(BaseNum);
        State.Profit+=context.Value.SumCOIN;
        WriteState(State);
    }
}

function OnSend()
{
    //Profit field
    var BaseNum=context.Smart.Account;
    if(context.Account.Num===BaseNum && context.Description!=="Move")
    {
        var State=ReadState(BaseNum);
        if(context.Value.SumCENT || context.Value.SumCOIN>State.Profit)
            throw "Not access";
        State.Profit-=context.Value.SumCOIN;
        WriteState(State);
    }
}



//client side

"public"
function Deposit(Params)//creation or replenishment of a cash account
{
    CheckPermission();

    var BaseNum=context.Smart.Account;
    var State=ReadState(BaseNum);
    if(!State.Open)
        throw "Reception of money is closed";

    var Amount=parseInt(Params.Amount);
    if(!Amount || Amount<State.MinAmount)
        throw "Error Amount.";

    if(Params.FromNum!==context.FromNum)
        throw "Error FromNum.";

    if(Params.PrevBlock!==State.DepositBlock || Params.PrevTr!==State.DepositTr)
        throw "Pls, try later. Error Prev item list.";

    State.DepositBlock=context.BlockNum;
    State.DepositTr=context.TrNum;
    WriteState(State);


    Send(BaseNum,Amount,"Deposit");

    Params.cmd="Deposit";
    Event(Params);
}



"public"
function Order(Params)//anonymous money transfer order
{
    var State=ReadState(context.Smart.Account);

    if(!Params.Hash || !Params.ToNum || !Params.Amount)
        throw "Error Params.";

    if(Params.PrevBlock!==State.OrderBlock || Params.PrevTr!==State.OrderTr)
        throw "Error Prev item list. Pls, try later.";

    State.OrderBlock=context.BlockNum;
    State.OrderTr=context.TrNum;
    WriteState(State);



    Params.cmd="Order";
    Event(Params);
}


//operator side


"public"
function SetConst(Params)
{
    CheckPermissionBase();

    var State=ReadState(context.Smart.Account);
    State.Open=Params.Open;
    State.MinAmount=Params.MinAmount;
    State.Fee=Params.Fee;
    WriteState(State);

    Params.cmd="SetConst";
    Event(Params);
}

"public"
function DoRun(Params)
{
    CheckPermissionBase();

    for(var i=0;i<Params.Send.length;i++)
    {
        var Item=Params.Send[i];
        var ToNum=parseInt(Item[0]);
        var Amount=parseInt(Item[1]);
        Send(ToNum,Amount,"Move");
    }

    var State=ReadState(context.Smart.Account);

    if(Params.PrevVer!==State.BalanceVer)//Check for "dirty reading"
        throw "BADPREVITEM";

    if(Params.DoAtom)
    {
        if(Params.DoAtom===1 && State.Atom===0)
            State.Atom=Params.Atom;
        else
        if(Params.DoAtom===2 && State.Atom===Params.Atom)
            State.Atom=0;
        else
            throw "BADATOM";
    }
    else
    if(State.Atom)
        throw "BADATOM";

    //OK
    State.BalanceVer=Params.Ver;
    State.BalanceBlock=context.BlockNum;
    State.BalanceTr=context.TrNum;

    State.DepositCompleted=Params.DC;
    State.OrderCompleted=Params.OC;
    State.Profit+=State.Fee*Params.Send.length;

    WriteState(State);


    Params.cmd="DoRun";
    Event(Params);
}





