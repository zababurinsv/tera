//{ProjNum:uint32, AddNum:uint, LibNum:uint32, HTMLBlock:uint,HTMLTr:uint16}


function GetWLib()
{
    var lib=require(119);//106
    return lib;
}
//----------------------------------------------------------------------------------------------------------------------

function OnGet()
{
    if(context.SmartMode)
        return;

    if(SetState())
        return;

    if(context.Description==="init")
        return;

    if(context.Account.Num===context.Smart.Account)
        return;


    var Storage=ReadProject();
    if(Storage.Start)
    {
        DoDeposit();
    }

    //Event("Not runing");
}


function OnSend()
{
    CheckManualAccess();
}


function OnDeleteSmart()
{
    CheckManualAccess();
}

//----------------------------------------------------------------------------------------------------------------------
function DoDeposit()
{

    var Project=ReadProject();
    if(Project.BlockNum && Project.BlockNum<context.BlockNum)
        throw "The fundraising period is over";


    ADD(Project.Value,context.Value);

    if(Project.MaxSum)
    {
        var FundAmount=FLOAT_FROM_COIN(Project.Value);
        if(FundAmount>Project.MaxSum)
            throw "Error fund max sum";
    }


    WriteProject(Project);


    var wlib=GetWLib();
    var AccObj=ReadAccount(context.FromNum);
    AccObj.ProjNum=context.Account.Num;
    wlib.AddCoin(AccObj,context.Value);

    //TERA move to base acc
    if(!context.Account.Currency)
        Send(context.Smart.Account,context.Value,"Deposit");
}

"public"
function Withdraw(Params)
{
    if(!context.FromNum)
        throw "Error anonymous access";

    var wlib=GetWLib();
    var Project=ReadProject();
    if(Project.BlockNum>context.BlockNum)
        throw "Wait final date";

    var Percent=0;
    var FundAmount=FLOAT_FROM_COIN(Project.Value);
    if(Project.MinSum)
        Percent=100*FundAmount/Project.MinSum;

    var AccFundN;
    if(context.Account.Currency)
        AccFundN=context.Account.Num;
    else
        AccFundN=context.Smart.Account;

    var AccFrom=ReadAccount(context.FromNum);
    AccFrom.ProjNum=context.Account.Num;
    var CurAmount=wlib.ReadCoin(AccFrom);


    if(Params.Refund)
    {
        if(!Project.Start  || (context.BlockNum>Project.BlockNum && Percent<100))
        {
            Move(AccFundN,context.FromNum,CurAmount,"Refund");
            wlib.SubCoin(AccFrom,CurAmount);


            if(!SUB(Project.Value,CurAmount))
                throw "Error sub operation";

            WriteProject(Project);

            return Event("OK Refund="+FLOAT_FROM_COIN(CurAmount));
        }
    }
    else
    if(Percent>=100)
    {
        var AccTo=ReadAccount(Params.ToNum);
        if(AccFrom.PubKeyStr!==AccTo.PubKeyStr)
            throw "Error access to account "+Params.ToNum;

        if(Params.Founder)
        {
            //founders fund
            for(var i=0;i<Project.ArrTo.length;i++)
            {
                var Item=Project.ArrTo[i];
                if(Item.AccNum===Params.ToNum && !Item.Sent)
                {
                    var Sum=Round(Item.Percent*FundAmount/100);
                    Move(AccFundN,Params.ToNum,COIN_FROM_FLOAT2(Sum),"Fund");

                    //reset
                    Item.Sent=1;
                    WriteProject(Project);
                    return Event("OK Founder="+Sum+" ("+AccFundN+"->"+Params.ToNum+")");
                }
            }

        }
        else
        if(Project.Mode && FundAmount)
        {
            //distribution of tokens
            var fCurAmount=FLOAT_FROM_COIN(CurAmount);
            var Sum=0;
            if(Project.Mode===1)
                Sum=Project.Rate*fCurAmount;
            else
            if(Project.Mode===2)
            {
                Sum=Project.TokenSum*fCurAmount/FundAmount;
            }


            if(Sum)
            {
                Move(Project.TokenAcc,Params.ToNum,COIN_FROM_FLOAT2(Sum),"Tokens");

                //reset
                wlib.SubCoin(AccFrom,CurAmount);
                return Event("OK Token");
            }


        }
    }

    Event("No withdraw");
}

//math
function COIN_FROM_FLOAT2(Sum)
{
    var MAX_SUM_CENT = 1e9;
    var SumCOIN=Math.floor(Sum);
    var SumCENT = Math.floor(Sum * MAX_SUM_CENT - SumCOIN * MAX_SUM_CENT);
    var Coin={SumCOIN:SumCOIN,SumCENT:SumCENT};
    return Coin;
}
function Round(Sum)
{
    return Math.floor(Sum*1e9)/1e9;
}

//----------------------------------------------------------------------------------------------------------------------
function SetState()
{
    if(context.SmartMode)
        return;

    if(context.Account.Num===context.Smart.Account
        && context.FromNum===context.Smart.Owner
        && context.Description.substr(0,1)==="{")
    {
        var State=ReadState(context.Smart.Account);
        var Data=JSON.parse(context.Description);
        for(var key in Data)
            State[key]=Data[key];
        WriteState(State);
        Event("State: "+JSON.stringify(State));
        return 1;
    }
    return 0;
}


//----------------------------------------------------------------------------------------------------------------------
//checks
function CheckManualAccess()
{
    if(context.SmartMode)
        return;
    var Storage=ReadProject();
    if(Storage.Start)
        throw "No access. The project was launched.";
}

function CheckPermission()
{
    if(context.Account.Num!==context.FromNum)
        throw "Access to "+context.Account.Num+" is allowed only from your own account.";
}


function CheckParams(Params)
{
    var SumP=0;
    for(var i=0;i<Params.ArrTo.length;i++)
        SumP+=Params.ArrTo[i].Percent;
    if(!Params.Name || !Params.Desc || !Params.MinSum || !Params.BlockNum || SumP!==100)
        throw "Error params";

    if(Params.Mode==1 && !Params.Rate)
        throw "Error Rate";
    if(Params.Mode==2 && !Params.TokenSum)
        throw "Error amount for sale";
    if(Params.Mode && !Params.TokenAcc)
        throw "Error tokens account";


}

//----------------------------------------------------------------------------------------------------------------------
//Params

"public"
function SetParams(Params)
{
    CheckPermission();
    CheckParams(Params);
    var ProjAccount=context.Account.Num;

    var Storage=ReadProject();
    if(Storage.Start)
        throw "Was started";


    for(var key in Params)
        Storage[key]=Params[key];

    var EventVal="Set params OK";

    if(Params.Start)
    {
        //ProjNum
        var State=ReadState(Params.TokenAcc);
        if(State.ProjNum && State.ProjNum!=ProjAccount)
            throw "Token Acc was set to another project="+State.ProjNum;
        State.ProjNum=ProjAccount;
        WriteState(State);

        Storage.Start=context.BlockNum;

        var List=ReadList();
        List.ArrNum.push(ProjAccount);
        WriteList(List);

        for(var i=0;i<Storage.ArrTo.length;i++)
            Storage.ArrTo[i].Sent=0;

        EventVal={cmd:"Start",Project:ProjAccount};
    }

    WriteProject(Storage);


    Event(EventVal);

}


//----------------------------------------------------------------------------------------------------------------------
function GetFList()
{
    var Format=
        {
            ArrNum:["uint32"]
        };

    return Format;
}

function ReadList()
{
    var Storage=ReadValue("List",GetFList());
    if(!Storage)
    {
        Storage=GetFProject();
        Storage.ArrNum=[];
    }
    return Storage;
}

function WriteList(Storage)
{
    WriteValue("List",Storage,GetFList());
}


//----------------------------------------------------------------------------------------------------------------------
function GetFProject()
{
    var Format=
        {
            Start:"uint32",
            BlockNum:"uint",
            MinSum:"double",
            MaxSum:"double",
            Mode:"byte",
            TokenAcc:"uint32",
            TokenSum:"double",
            Rate:"double",
            ArrTo:[{AccNum:"uint32",Percent:"double",Sent:"byte"}],
            Name:"str",
            Desc:"str",
            Img:"str",
            Url:"str",
            Value:{SumCOIN:"uint", SumCENT:"uint32"},
            Currency:"uint32",
            CurrencyT:"uint32",
        };

    return Format;
}


function ReadProject()
{
    var ProjNum=context.Account.Num;
    var Storage=ReadValue("Project:"+ProjNum,GetFProject());
    if(!Storage)
    {
        Storage=GetFProject();
        for(var key in Storage)
        {
            var type=Storage[key];
            if(type==="str")
                Storage[key]="";
            else
                Storage[key]=0;
        }
        Storage.ArrTo=[];
        Storage.Value={SumCOIN:0, SumCENT:0};
    }
    return Storage;
}


function WriteProject(Storage)
{
    var ProjNum=context.Account.Num;
    Storage.Currency=context.Account.Currency;
    if(Storage.TokenAcc)
    {
        var Acc=ReadAccount(Storage.TokenAcc);
        Storage.CurrencyT=Acc.Currency;
    }
    WriteValue("Project:"+ProjNum,Storage,GetFProject());
}

//----------------------------------------------------------------------------------------------------------------------
"public"
function LibProcess(Params)
{
    var State=ReadState(context.Smart.Account);
    if(!State.LibNum)
        return;

    var lib=require(State.LibNum);
    lib.LibProcess(Params);
}


//----------------------------------------------------------------------------------------------------------------------


//static call
"public"
function GetProject()
{
    var Data=ReadProject();
    return Data;
}


"public"
function GetList()
{
    return ReadList();
}



