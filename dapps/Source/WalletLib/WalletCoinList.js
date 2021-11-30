//{HTMLBlock:uint,HTMLTr:uint16}

function OnGet()//on getting coins
{
    if(SetState())
        return;

}

"public"
function SetList(Params)
{
    CheckPermission();
    WriteValue("LIST",Params.Value,GetFormat());
}



"public"
function SetKey(Params)
{
    CheckPermission();
    WriteValue(Params.Key,Params.Value,Params.Format);
}



"public"
function RemoveKey(Params)
{
    CheckPermission();
    return RemoveValue(Params.Key);
}


function GetFormat()
{
    return [{Num:"uint32",Name:"str8",Flag:"uint"}];
}

//for static call

"public"
function GetList()
{
    return ReadValue("LIST",GetFormat());
}

"public"
function GetKey(Params)
{
    return ReadValue(Params.Key,Params.Format);
}


function CheckPermission()
{
    if(context.FromNum!==context.Smart.Owner)
        throw "You need to specify the Owner account number";
}

function SetState()
{
    if(context.Account.Num===context.Smart.Account
        && context.FromNum===context.Smart.Owner
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


