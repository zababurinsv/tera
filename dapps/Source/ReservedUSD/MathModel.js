global.ToLog=console.log;

var KFee=0.002;
var KReserve,KSwap,KDAO;
var USDPool=0;
var TeraPool=0;
var ReservePool=0;
var USDAll=0;
var DAOAll=0;
var FeePool=0;

function CalcK()
{
    if(USDAll && ReservePool)
    {
        KReserve=USDAll / ReservePool
    }
    else
    {
        KReserve=0.001;
    }

    if(USDPool && TeraPool)
    {
        KSwap=USDPool / TeraPool;
    }
    else
    {
        KSwap=0.003;
    }

    if(DAOAll && ReservePool && TeraPool)
    {
        //KDAO=DAOAll/(ReservePool+TeraPool);
        KDAO=1/(1+FeePool/DAOAll);
    }
    else
    {
        KDAO=1;
    }
}

function LogInfo()
{
    ToLog("--------------------");
    ToLog("FeePool: "+FeePool);
    ToLog("ReservePool: "+ReservePool);
    ToLog("TeraPool: "+TeraPool);
    ToLog("USDPool: "+USDPool);
    ToLog("USDAll: "+USDAll);
    ToLog("DAOAll: "+DAOAll);
    ToLog("");
    ToLog("KReserve="+KReserve);
    ToLog("KSwap="+KSwap);
    ToLog("KDAO="+KDAO);
}

function AddLiq(TDeposit,Mode)
{
    if(TDeposit<1e-9)
        return;

    CalcK();

    var TeraToReserve;
    if(Mode===1)
        TeraToReserve=0;
    else
    if(Mode===2)
        TeraToReserve=TDeposit;
    else
        TeraToReserve=TDeposit/(KReserve/KSwap+1);

    var TeraToPool=TDeposit-TeraToReserve;

    var USDToPool =TeraToReserve*KReserve;


    var DAO=TDeposit*KDAO;


    TeraPool+=TeraToPool;
    USDPool+=USDToPool ;
    USDAll+=USDToPool ;
    ReservePool+=TeraToReserve;
    DAOAll+=DAO;

    var AmountFee = DAO*(1/KDAO-1);
    FeePool += AmountFee;


    CalcK();
    LogInfo();

    ToLog("DAO out="+DAO);
}

function RemoveLiq(DAOBurned)
{
    if(DAOBurned<1e-9)
        return;

    CalcK();

    var TeraWithdrawn = DAOBurned/KDAO;
    var TeraFromReserve = TeraWithdrawn /(KReserve/KSwap+1);
    var TeraFromPool  = TeraWithdrawn  - TeraFromReserve;
    var USDFromPool = TeraFromPool*KSwap;
    if(TeraPool<=TeraFromPool)
        throw "Error amount pool Tera";
    if(USDPool<=USDFromPool)
        throw "Error amount pool USD";
    if(ReservePool<=TeraFromReserve)
        throw "Error amount reserve Tera";

    TeraPool-=TeraFromPool;
    USDPool-=USDFromPool;
    USDAll-=USDFromPool;
    ReservePool-=TeraFromReserve;
    DAOAll-=DAOBurned;

    var AmountFee = DAOBurned*(1/KDAO-1);
    FeePool -= AmountFee;

    LogInfo();

    ToLog("Tera out="+TeraWithdrawn);

}

function Rebalance(KReserveNew)
{
    CalcK();

    if(KReserveNew===KReserve)
        return;
    if(KReserveNew<1e-9)
        throw "Error KReserveNew="+KReserveNew;



    var DeltaTera=(ReservePool-USDAll/KReserveNew)/(1+KSwap/KReserveNew);
    var DeltaUSD = DeltaTera*KSwap;

    //var ReservePoolNew=ReservePool-DeltaTera;
    //ToLog("ReservePoolNew="+ReservePoolNew);

    if(DeltaTera>0)//выпуск дополнительных USD и увеличение пула обмена USD/TERA
    {
        if(ReservePool<=DeltaTera)
            throw "Error amount reserve Tera";
    }
    else//нужно уменьшить пул обмена
    {
        if(TeraPool<=-DeltaTera)
            throw "Error amount pool Tera";
        if(USDPool<=-DeltaUSD)
            throw "Error amount pool USD";
    }

    TeraPool+=DeltaTera;
    USDPool+=DeltaUSD;
    USDAll+=DeltaUSD;
    ReservePool-=DeltaTera;//rebalance

    CalcK();
    LogInfo();

    ToLog("DeltaTera="+DeltaTera);
    ToLog("DeltaUSD="+DeltaUSD);

    if(Math.floor(KReserveNew*1e6)!==Math.floor(KReserve*1e6))
        throw "Error pool balance";
}


//-----------SWAP

function SwapTeraToUSD(AmountTera)
{
    if(AmountTera<1e-9)
        return 0;

    //var KFee=0.1;
    var AmountFee=AmountTera*KFee;
    var Invariant=TeraPool * USDPool;
    var TeraPoolNew = TeraPool + AmountTera;
    var USDPoolNew = Invariant/(TeraPoolNew - AmountFee);
    var USDOut = USDPool - USDPoolNew;

    var USDFee = USDPoolNew - Invariant/TeraPoolNew;
    var TeraFee = USDFee*TeraPoolNew/USDPool;//комиссия с учетом эффекта "проскальзывания"


    TeraPool = TeraPoolNew;
    USDPool = USDPoolNew;

    FeePool += TeraFee;


    CalcK();
    LogInfo();

    ToLog("USD out="+USDOut);
    // ToLog("Invariant="+Invariant);
    // ToLog("InvariantNew="+TeraPool * USDPool);

    return USDOut;
}

function SwapUSDToTera(AmountUSD)
{
    if(AmountUSD<1e-9)
        return 0;


    //var KFee=0;
    var AmountFee=AmountUSD*KFee;
    var Invariant=TeraPool * USDPool;
    var USDPoolNew = USDPool + AmountUSD;
    var TeraPoolNew = Invariant / (USDPoolNew - AmountFee);
    var TeraFee = TeraPoolNew - Invariant / USDPoolNew;

    var TeraOut = TeraPool - TeraPoolNew;
    TeraPool = TeraPoolNew;
    USDPool = USDPoolNew;

    FeePool += TeraFee;

    CalcK();
    LogInfo();

    ToLog("Tera out="+TeraOut);
    // ToLog("Invariant="+Invariant);
    // ToLog("InvariantNew="+TeraPool * USDPool);

    return TeraOut;
}


AddLiq(50000,4);
//AddLiq(1000,3);
//AddLiq(10,2);
// AddLiq(10);
// AddLiq(10);
// AddLiq(10);
// AddLiq(10);

// AddLiq(500);
// RemoveLiq(1000);
// AddLiq(500);
//Rebalance(KReserve*2);
var AmountUSD=SwapTeraToUSD(1000);
var AmountTera=SwapUSDToTera(AmountUSD);

ToLog("Check: "+(AmountTera+FeePool));




