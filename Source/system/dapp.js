/*
 * @project: TERA
 * @version: Development (beta)
 * @license: MIT (not for evil)
 * @copyright: Yuriy Ivanov (Vtools) 2017-2020 [progr76@gmail.com]
 * Web: https://terafoundation.org
 * Twitter: https://twitter.com/terafoundation
 * Telegram:  https://t.me/terafoundation
*/

"use strict";

const fs = require('fs');

class DApp
{
    constructor()
    {
    }
    Name()
    {
        throw "Need method Name()";
    }
    
    GetFormatTransaction(Type)
    {
        return "";
    }
    
    GetObjectTransaction(Body)
    {
        var Type = Body[0];
        var format = GetFormatTransactionCommon(Type);
        if(!format)
            return {"Type":Type, Data:GetHexFromArr(Body)};
        
        var TR;
        try
        {
            TR = SerializeLib.GetObjectFromBuffer(Body, format, {})
        }
        catch(e)
        {
        }
        return TR;
    }
    
    GetScriptTransaction(Body, BlockNum, TxNum)
    {
        var Type = Body[0];
        var format = GetFormatTransactionCommon(Type);
        if(!format)
            return GetHexFromArr(Body);
        
        var TR = SerializeLib.GetObjectFromBuffer(Body, format, {});
        
        if(Type === TYPE_TRANSACTION_TRANSFER && TR.Body && TR.Body.length)
        {
            var App = DAppByType[TR.Body[0]];
            if(App)
            {
                TR.Body = JSON.parse(App.GetScriptTransaction(TR.Body, BlockNum, TxNum))
            }
        }
        
        ConvertBufferToStr(TR)
        return JSON.stringify(TR, "", 2);
    }
    
    ClearDataBase()
    {
    }
    Close()
    {
    }
    GetSenderNum(BlockNum, Body)
    {
        return 0;
    }
    GetSenderOperationID(BlockNum, Body)
    {
        return 0;
    }
    CheckSignTransferTx(BlockNum, Body)
    {
        return 0;
    }
    
    CheckSignAccountTx(BlockNum, Body)
    {
        var FromNum = this.GetSenderNum(BlockNum, Body);
        if(!FromNum)
            return 0;
        var AccountFrom = ACCOUNTS.ReadState(FromNum);
        if(!AccountFrom)
            return 0;
        
        var hash = Buffer.from(sha3(Body.slice(0, Body.length - 64)));
        var Sign = Buffer.from(Body.slice(Body.length - 64));
        var Result = CheckSign(hash, Sign, AccountFrom.PubKey);
        
        return Result;
    }
    OnProcessBlockStart(Block)
    {
    }
    OnProcessBlockFinish(Block)
    {
    }
    OnDeleteBlock(BlockNum)
    {
    }
    OnProcessTransaction(Block, Body, BlockNum, TrNum)
    {
    }
    
    GetScrollList(DB, start, count)
    {
        var arr = [];
        for(var num = start; true; num++)
        {
            var Data = DB.Read(num);
            if(!Data)
                break;
            
            arr.push(Data)
            
            count--
            if(count < 1)
                break;
        }
        
        return arr;
    }
};
module.exports = DApp;

function GetFormatTransactionCommon(Type)
{
    var App = DAppByType[Type];
    if(App)
        return App.GetFormatTransaction(Type);
    else
        return "";
}

function ReqDir(Path)
{
    if(fs.existsSync(Path))
    {
        var arr = fs.readdirSync(Path);
        for(var i = 0; i < arr.length; i++)
        {
            var name = arr[i];
            ToLog("Reg: " + name);
            var name2 = Path + "/" + arr[i];
            require(name2);
        }
    }
}


global.DApps = {};
global.DAppByType = {};

global.REGISTER_SYS_DAPP = function (App,Type)
{
    var Name = App.Name();
    
    DApps[Name] = App;
    if(DAppByType[Type])
    {
        throw "Error on registering app " + App.Name() + ": tx type = " + Type + " has already been registered in the app " + DAppByType[Type].Name();
    }
    
    DAppByType[Type] = App;
}
