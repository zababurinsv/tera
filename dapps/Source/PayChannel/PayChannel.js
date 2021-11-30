//{HTMLBlock:uint,HTMLTr:uint16,CrossShard:str8,CrossAccount:uint32,Confirms:uint32}


function CheckStateSetting()
{

    if(context.FromNum===context.Account.Num
        && context.Description.substr(0,1)==="{")
    {
        var Data=JSON.parse(context.Description);
        var CurItem=ReadState(context.Account.Num);
        for(var key in Data)
            CurItem[key]=Data[key];
        WriteState(CurItem);
        Event("Set new State = "+JSON.stringify(CurItem));
        return 1;
    }
    return 0;
}




//------------ shard1

function OnGet()
{
    if(CheckStateSetting())
        return;


    var Desc=context.Description;

    var Index=Desc.indexOf(":");
    if(Index>0)
    {
        var Gate = Desc.substr(0,Index);
        Desc = Desc.substr(Index+1);

        var To;
        Index = Desc.indexOf(":");
        if (Index > 0)
        {
            To=Desc.substr(0,Index);
            Desc=Desc.substr(Index+1);
        }
        else
        {
            To=Desc;
            Desc="";
        }

        if(To)
        {
            var Sum=FLOAT_FROM_COIN(context.Value);
            DoSend(Gate,To,Sum,Desc);
            return;
        }
        throw "Error pay channel description";
    }


}


function DoSend(Gate,To,Sum,Desc)
{
    var Item=ReadState(context.Account.Num);


    //we send a command to move the token to another shard
    SendMessage(Item.CrossShard+":"+Gate,Item.Confirms,"SendCoins",{To:To,Sum:Sum,Desc:Desc});

    //a message to dappa
    Event("Sent "+Sum+" to "+Item.CrossShard+":"+Gate+":"+To+" "+Desc+" - OK");

}



//------------ shard2

"message"
function SendCoins(Params,ParamsArr)
{
    //checking the correct call - from the correct shard and the correct smart contract
    var Item=ReadState(context.Account.Num);

    if (context.Tx.ShardFrom!==Item.CrossShard)
        throw "Error cross-shard name: "+context.Tx.ShardFrom+" need:"+Item.CrossShard;

    if (context.Tx.AccountFrom!==Item.CrossAccount)
        throw "Error cross-gate: "+context.Tx.AccountFrom+" need:"+Item.CrossAccount;

    if (context.Tx.Confirms!==Item.Confirms)
        throw "Error confirms: "+context.Tx.Confirms+" need: "+Item.Confirms;



    //sending a token
    Send(Params.To, Params.Sum,Params.Desc);

}



