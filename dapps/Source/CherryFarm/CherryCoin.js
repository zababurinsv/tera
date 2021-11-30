//{TotalSum:double, HTMLBlock:uint,HTMLTr:uint16}

function OnGet()//on getting coins
{
    if(SetStateFromOwner())
        return;

}

function OnCreate()//creating this smart
{
    var AccObj=ReadAccount(context.Smart.Account);
    var State=ReadState(context.Smart.Account);
    State.TotalSum=FLOAT_FROM_COIN(AccObj.Value);
    WriteState(State);
}

function SetStateFromOwner()
{
    if(context.FromNum===context.Smart.Owner
        && context.Description.substr(0,1)==="{")
    {

        var State=ReadState(context.Smart.Account);
        var Data=JSON.parse(context.Description);
        for(var key in Data)
            State[key]=Data[key];

        WriteState(State);
        Event(State);
        return 1;
    }
    return 0;
}




"public"
function MintCoin(Params)
{
    if(context.FromNum!==context.Smart.Owner)
        return 0;

    var State=ReadState(context.Smart.Account);
    State.TotalSum+=Params.Sum;
    WriteState(State);

    var AccObj=ReadAccount(context.Smart.Account);
    var Value=AccObj.Value;
    ADD(Value,COIN_FROM_FLOAT(Params.Sum));

    SetValue(context.Smart.Account,Value);

    Event("New value: "+FLOAT_FROM_COIN(Value));

}



