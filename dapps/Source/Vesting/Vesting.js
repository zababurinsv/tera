
function GetLib()
{
    return require(8);//List-lib
}

function CheckPermission()
{
    if(context.Account.Num!==context.FromNum)
        throw "Access is allowed only from your own account.";
}

function OnGet()
{
    var lib=GetLib();
    if(lib.OnGet())
        return;
}


function OnSend()
{
    CheckFreeze(0);
}

function OnDeleteSmart()
{
    CheckFreeze(1);
}


function CheckFreeze(bSimple)
{
    var State=ReadState(context.Account.Num);
    if(State.BlockTo>context.BlockNum)
    {
        if(bSimple)
            throw "Account is frozen until the block: "+State.BlockTo;

        var Value=context.Account.Value;
        if(!SUB(Value,State.ValueFreeze))
        {
            throw "Account is frozen until the block: "+State.BlockTo;
        }
    }
    return 1;
}

"public"
function Freeze(Params)
{
    CheckPermission();
    CheckFreeze(1);

    var State=ReadState(context.Account.Num);
    State.BlockTo=Params.BlockTo;
    State.ValueFreeze=Params.ValueFreeze;
    WriteState(State);

    Event("Freeze");
}


