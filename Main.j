globals
    hashtable hash = InitHashtable()
    real START_TIMER = 40.5
endglobals

function SR takes timer t,string s, real r returns nothing
call SaveReal(hash,GetHandleId(t),StringHash(s),r)
endfunction
function SU takes timer t,string s, unit u returns nothing
call SaveUnitHandle(hash,GetHandleId(t),StringHash(s),u)
endfunction
function SI takes timer t,string s, integer i returns nothing
call SaveInteger(hash,GetHandleId(t),StringHash(s),i)
endfunction
function SG takes timer t,string s, group g returns nothing
call SaveGroupHandle(hash,GetHandleId(t),StringHash(s),g)
endfunction
function SB takes timer t,string s, boolean b returns nothing
call SaveBoolean(hash,GetHandleId(t),StringHash(s),b)
endfunction
function SL takes timer t,string s, location b returns nothing
call SaveLocationHandle(hash,GetHandleId(t),StringHash(s),b)
endfunction
function ST takes unit u,string s, timer t returns nothing
call SaveTimerHandle(hash,GetHandleId(u),StringHash(s),t)
endfunction
function GT takes unit u,string s returns timer
return LoadTimerHandle(hash,GetHandleId(u),StringHash(s))
endfunction
function GL takes timer t,string s returns location
return LoadLocationHandle(hash,GetHandleId(t),StringHash(s))
endfunction
function GB takes timer t,string s returns boolean
return LoadBoolean(hash,GetHandleId(t),StringHash(s))
endfunction
function GG takes timer t,string s returns group
return LoadGroupHandle(hash,GetHandleId(t),StringHash(s))
endfunction
function GI takes timer t,string s returns integer
return LoadInteger(hash,GetHandleId(t),StringHash(s))
endfunction
function GU takes timer t,string s returns unit
return LoadUnitHandle(hash,GetHandleId(t),StringHash(s))
endfunction
function GR takes timer t,string s returns real
return LoadReal(hash,GetHandleId(t),StringHash(s))
endfunction
function USR takes unit t,string s, real r returns nothing
call SaveReal(hash,GetHandleId(t),StringHash(s),r)
endfunction
function USU takes unit t,string s, unit u returns nothing
call SaveUnitHandle(hash,GetHandleId(t),StringHash(s),u)
endfunction
function USI takes unit t,string s, integer i returns nothing
call SaveInteger(hash,GetHandleId(t),StringHash(s),i)
endfunction
function USG takes unit t,string s, group g returns nothing
call SaveGroupHandle(hash,GetHandleId(t),StringHash(s),g)
endfunction
function USB takes unit t,string s, boolean b returns nothing
call SaveBoolean(hash,GetHandleId(t),StringHash(s),b)
endfunction
function USL takes unit t,string s, location b returns nothing
call SaveLocationHandle(hash,GetHandleId(t),StringHash(s),b)
endfunction
function UGL takes unit t,string s returns location
return LoadLocationHandle(hash,GetHandleId(t),StringHash(s))
endfunction
function UGB takes unit t,string s returns boolean
return LoadBoolean(hash,GetHandleId(t),StringHash(s))
endfunction
function UGG takes unit t,string s returns group
return LoadGroupHandle(hash,GetHandleId(t),StringHash(s))
endfunction
function UGI takes unit t,string s returns integer
return LoadInteger(hash,GetHandleId(t),StringHash(s))
endfunction
function UGU takes unit t,string s returns unit
return LoadUnitHandle(hash,GetHandleId(t),StringHash(s))
endfunction
function UGR takes unit t,string s returns real
return LoadReal(hash,GetHandleId(t),StringHash(s))
endfunction

function SetUnitAnimationTimeOver takes nothing returns nothing
local timer t = GetExpiredTimer()
local unit u = LoadUnitHandle(hash,GetHandleId(t),StringHash("caster"))
local integer i = LoadInteger(hash,GetHandleId(t),StringHash("Index"))
call SetUnitAnimationByIndex(u,i)
call FlushChildHashtable(hash,GetHandleId(t))
call DestroyTimer(t)
set t = null
set u = null
endfunction

//유닛의 -애니메이션번호를 -초후 로 설정합니다. 
function SetUnitAnimationNumber takes unit u , integer index , real time returns nothing
local timer t = LoadTimerHandle(hash,GetHandleId(u),StringHash("AnimationNumberTimer"))
if t == null then
set t = CreateTimer()
call SaveTimerHandle(hash,GetHandleId(u),StringHash("AnimationNumberTimer"),t)
endif
call SaveInteger(hash,GetHandleId(t),StringHash("index"),index)
call SaveInteger(hash,GetHandleId(u),StringHash("uindex"),index)
call SaveUnitHandle(hash,GetHandleId(t),StringHash("caster"),u)
call TimerStart(t,time,false,function SetUnitAnimationTimeOver)
set t = null
endfunction

//유닛의 애니메이션속도를 -초후 -%로 설정합니다. 
function SetUnitAnimationSpeedTimeOver takes nothing returns nothing
call SetUnitTimeScalePercent(LoadUnitHandle(hash,GetHandleId(GetExpiredTimer()),StringHash("u")),LoadReal(hash,GetHandleId(GetExpiredTimer()),StringHash("p")))
call SaveReal(hash,GetHandleId(LoadUnitHandle(hash,GetHandleId(GetExpiredTimer()),StringHash("u"))),StringHash("AnimationSpeed"),LoadReal(hash,GetHandleId(GetExpiredTimer()),StringHash("p")))
call DestroyTimer(GetExpiredTimer())
endfunction

//유닛의 애니메이션속도를 -초후 -%로 설정합니다. 
function SetUnitAnimationSpeed takes unit u , real time,real percent returns nothing
local timer t = LoadTimerHandle(hash,GetHandleId(u),StringHash("AnimationTimer"))
if t == null then
set t =CreateTimer()
call SaveTimerHandle(hash,GetHandleId(u),StringHash("AnimationTimer"),t)
endif
call SaveUnitHandle(hash,GetHandleId(t),StringHash("u"),u)
call SaveReal(hash,GetHandleId(t),StringHash("p"),percent)
call TimerStart(t,time,false,function SetUnitAnimationSpeedTimeOver)
set t = null
endfunction


//채널애니함수
function Animate1 takes nothing returns nothing
local timer t = GetExpiredTimer()
local unit u = GU(t,"u")
local integer i = GI(t,"i")
call SetUnitAnimationByIndex(u,i)
call FlushChildHashtable(bj_lastCreatedHashtable,GetHandleId(t))
set u = null
call DestroyTimer(t)
set t = null
endfunction

function Animate takes unit u, integer i returns nothing
local timer t = CreateTimer()
call SU(t,"u",u)
call SI(t,"i",i)
call TimerStart(t,0,false,function Animate1)
set t = null
endfunction



//SetUnitX+SetUnitY 
function SetUnitAtLoc takes unit u, location L, boolean deleted returns nothing
call SetUnitX(u,GetLocationX(L))
call SetUnitY(u,GetLocationY(L))
if deleted then
call RemoveLocation(L)
endif
endfunction

function GetParabolaZ takes real x,real d,real h returns real
    return 4 * h * x * (d - x) / (d * d)
endfunction

function IsPointPathable takes real x,real y returns boolean
 local boolean b
 local real ix
 local real iy
 call SetItemPosition(udg_PathCheckI,x,y)
 set ix=GetItemX(udg_PathCheckI)
 set iy=GetItemY(udg_PathCheckI)
 set b=(x-ix)*(x-ix)+(y-iy)*(y-iy)<=2.00
 call SetItemVisible(udg_PathCheckI,false)
 return b
endfunction

function IsPointFlyable takes real x,real y returns boolean
 local boolean b
 local real ux
 local real uy
 call SetUnitPosition(udg_PathCheckU,x,y)
 set ux=GetUnitX(udg_PathCheckU)
 set uy=GetUnitY(udg_PathCheckU)
 set b=(x-ux)*(x-ux)+(y-uy)*(y-uy)<=2.00
 call ShowUnit(udg_PathCheckU,false)
 return b
endfunction

//두 유닛사이의 거리를 구하는 함수 
function DistanceBetweenUnits takes unit u1, unit u2 returns real
 local real x = GetUnitX(u2)-GetUnitX(u1)
 local real y = GetUnitY(u2)-GetUnitY(u1)
 return SquareRoot(x*x+y*y)
endfunction

//1줄용 스턴 (1부터 9까지 0.5초씩 스턴 증가) : 트리거를 벗어나면 무효임 
function stun takes integer sturnTime returns nothing
    local location loc = GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLoc( 1, 'h00F', GetOwningPlayer(GetTriggerUnit()), loc, GetUnitFacing(GetTriggerUnit()) )
    call SetUnitAbilityLevelSwapped( 'A038', GetLastCreatedUnit(), sturnTime )
    call IssueTargetOrderBJ( GetLastCreatedUnit(), "thunderbolt", GetSpellTargetUnit() )
    call RemoveLocation(loc)
    set loc = null
endfunction

//범위용 스턴 (스턴을 거는 사람,  1부터 9까지 0.5초씩 스턴 증가) 그룹 내에서만 사용할 것 
function stunAll takes unit me, integer stunTime returns nothing
    local location array loc
    set loc[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))] = GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLoc( 1, 'h00F', GetOwningPlayer(me), loc[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))], GetUnitFacing(GetEnumUnit()) )
    call SetUnitAbilityLevelSwapped( 'A038', GetLastCreatedUnit(), stunTime )
    call IssueTargetOrderBJ( GetLastCreatedUnit(), "thunderbolt", GetEnumUnit() )
    call RemoveLocation( loc[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))] )
    set loc[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))] = null
endfunction

function inoken takes nothing returns nothing
    local real x = GetUnitX(udg_StiylDdummy1) + GetRandomReal(-400.00, 400.00)
    local real y = GetUnitY(udg_StiylDdummy1) + GetRandomReal(-400.00, 400.00)
    local unit b = CreateUnit(GetOwningPlayer(udg_StiylDdummy1), 'h00X', x, y, bj_UNIT_FACING)
    call SetUnitAbilityLevelSwapped( 'A04U', b, (R2I(udg_StiylAb2boolean) + 1))
    call IssuePointOrder(b, "clusterrockets", x, y)
    set b = null
endfunction

 function poisond takes nothing returns nothing
   local timer t = GetExpiredTimer()
   local unit sour = LoadUnitHandleBJ(1,GetHandleId(t),udg_Hash[1])
   local unit targ = LoadUnitHandleBJ(2,GetHandleId(t),udg_Hash[1])
   local real dmgp = LoadRealBJ(3,GetHandleId(t),udg_Hash[1])
   local string efft = LoadStringBJ(4,GetHandleId(t),udg_Hash[1])
   local integer span = LoadInteger(udg_Hash[1],GetHandleId(t),5)
   local integer i = LoadInteger(udg_Hash[1],GetHandleId(t),6)
  if i < span and IsUnitAliveBJ(targ) then
   call UnitDamageTargetBJ(sour,targ,dmgp,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_ENHANCED)
   call DestroyEffect(AddSpecialEffectTarget(efft,targ,"origin"))
   call SaveInteger(udg_Hash[1],GetHandleId(t),6,i+1)
  else
   call PauseTimer(t)
   call FlushChildHashtableBJ(GetHandleId(t),udg_Hash[1])
   call DestroyTimer(t)
  endif
   set t = null
   set sour = null
   set targ = null
  endfunction
   
 function Poison takes unit sour, unit targ, integer span, real freq, real dmgp, string efft returns nothing
    local timer t = CreateTimer()
  call SaveUnitHandleBJ(sour,1,GetHandleId(t),udg_Hash[1])
  call SaveUnitHandleBJ(targ,2,GetHandleId(t),udg_Hash[1])
  call SaveRealBJ(dmgp,3,GetHandleId(t),udg_Hash[1])
  call SaveStringBJ(efft,4,GetHandleId(t),udg_Hash[1])
  call SaveInteger(udg_Hash[1],GetHandleId(t),5,span)
  call SaveInteger(udg_Hash[1],GetHandleId(t),6,0)
  call TimerStart(t,freq,true,function poisond)
  set t = null
 endfunction

function smove2 takes nothing returns nothing
 local timer t = GetExpiredTimer()
 local unit tar = LoadUnitHandle(udg_Hash[1],GetHandleId(t),1)
 local real dis = LoadReal(udg_Hash[1],GetHandleId(t),2)
  local real ang = LoadReal(udg_Hash[1],GetHandleId(t),3)
   local real dis2 = LoadReal(udg_Hash[1],GetHandleId(t),4)
    local real num = dis/dis2
     local integer num2 = LoadInteger(udg_Hash[1],GetHandleId(t),7)
 local real loc2x = LoadReal(udg_Hash[1],GetHandleId(t),5) + dis2 * Cos(ang * bj_DEGTORAD)
 local real loc2y = LoadReal(udg_Hash[1],GetHandleId(t),6) + dis2 * Sin(ang * bj_DEGTORAD) 
  
  if num2<num and IsUnitAliveBJ(tar) then
 call SetUnitPosition(tar,loc2x,loc2y)
 call SaveInteger(udg_Hash[1],GetHandleId(t),7,num2+1)
 call SaveReal(udg_Hash[1],GetHandleId(t),5,loc2x)
 call SaveReal(udg_Hash[1],GetHandleId(t),6,loc2y)
  else
  call FlushChildHashtable(udg_Hash[1],GetHandleId(t))
  call DestroyTimer(t)
  endif
  
  set tar = null
  set t = null
endfunction

function smove takes unit tar, real dis, real dis2, real ang, real fre returns nothing
 local timer t = CreateTimer()
 local location loc = GetUnitLoc(tar)
 local real locx = GetLocationX(loc)
 local real locy = GetLocationY(loc)
 call SaveUnitHandle(udg_Hash[1],GetHandleId(t),1,tar)
 call SaveReal(udg_Hash[1],GetHandleId(t),2,dis)
 call SaveReal(udg_Hash[1],GetHandleId(t),3,ang)
 call SaveReal(udg_Hash[1],GetHandleId(t),4,dis2)
 call SaveReal(udg_Hash[1],GetHandleId(t),5,locx)
 call SaveReal(udg_Hash[1],GetHandleId(t),6,locy)
 call SaveInteger(udg_Hash[1],GetHandleId(t),7,0)
 call TimerStart(t,fre,true,function smove2)
 set t = null
 call RemoveLocation(loc)
 set loc = null 
endfunction  

function Pathable takes real x, real y returns boolean
 local boolean n
 local real nx
 local real ny
 call SetItemPosition(udg_IsPointPathableCheckItem,x,y)
 set nx = GetItemX(udg_IsPointPathableCheckItem)
 set ny = GetItemY(udg_IsPointPathableCheckItem)
 set n = (x-nx)*(x-nx)+(y-ny)*(y-ny)<=2.0
 call SetItemVisible(udg_IsPointPathableCheckItem,false)
 return n
endfunction

function Flyable takes real x, real y returns boolean
 local boolean n
 local real nx
 local real ny
 local location L
 set L = Location(x, y)
 call SetUnitPositionLoc(udg_IsPointPathableCheckUnit,(L))
 set nx=GetUnitX(udg_IsPointPathableCheckUnit)
 set ny=GetUnitY(udg_IsPointPathableCheckUnit)
 set n=(x-nx)*(x-nx)+(y-ny)*(y-ny)<=2.0
 call ShowUnit(udg_IsPointPathableCheckUnit,false)
 call RemoveLocation(L)
 return n
endfunction

function PathableL takes location L returns boolean
    return Pathable(GetLocationX(L),GetLocationY(L))
endfunction

function PathableLD takes location L, unit u returns boolean
local location L2 = GetUnitLoc(u)

if GetTerrainCliffLevelBJ(L2) == GetTerrainCliffLevelBJ(L) then
    call RemoveLocation(L2)
    return Pathable(GetLocationX(L),GetLocationY(L))
else
    call RemoveLocation(L2)
    return false
endif

endfunction

function FlyableL takes location L returns boolean
    return Flyable(GetLocationX(L),GetLocationY(L))
endfunction

function TotalableL takes location L returns boolean
    return Pathable(GetLocationX(L), GetLocationY(L)) and Flyable(GetLocationX(L), GetLocationY(L))
endfunction

function SetUnitAtLocC takes unit u, location L, boolean deleted returns nothing
if PathableL(L) == true then
call SetUnitX(u,GetLocationX(L))
call SetUnitY(u,GetLocationY(L))
endif
if deleted then
call RemoveLocation(L)
endif
endfunction

//knock back
function NB2 takes nothing returns nothing
local timer t = GetExpiredTimer()
local unit u = LoadUnitHandle(bj_lastCreatedHashtable,GetHandleId(t),10)
local location c = LoadLocationHandle(bj_lastCreatedHashtable,GetHandleId(t),11)
local integer i = LoadInteger(bj_lastCreatedHashtable,GetHandleId(t),12)
if i <= 0 then
call SetUnitAtLocC((u), (c), false )
call RemoveLocation(c)
call PauseTimerBJ(true, (t))
call DestroyTimer(t)
call FlushChildHashtableBJ(GetHandleId(t),bj_lastCreatedHashtable)
else
call SaveInteger(bj_lastCreatedHashtable,GetHandleId(t),12,i - 1) 
call SetUnitAtLocC((u), (c), false )
endif
set t = null
set u = null
set c = null
endfunction

function NB takes unit u, location c, integer i, real r returns nothing
local timer t = CreateTimer()
call SaveUnitHandleBJ( u, 10,          GetHandleId(t), bj_lastCreatedHashtable )
call SaveLocationHandleBJ( c, 11,          GetHandleId(t), bj_lastCreatedHashtable )
call SaveInteger(bj_lastCreatedHashtable,GetHandleId(t),12,i) 
call TimerStart(t,r,true,function NB2)
set t = null
endfunction

function ED2 takes nothing returns nothing
local timer t = GetExpiredTimer()
call DestroyEffectBJ( LoadEffectHandle(bj_lastCreatedHashtable,GetHandleId(t),StringHash("source")) )
call FlushChildHashtableBJ(GetHandleId(t),bj_lastCreatedHashtable)
call DestroyTimer(t)
set t = null
endfunction

function ED1 takes effect e, real time returns nothing
local timer t = CreateTimer()
call SaveEffectHandle(bj_lastCreatedHashtable,GetHandleId(t),StringHash("source"),e)
call TimerStart(t,time,false,function ED2)
endfunction

function UR_Action takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local unit u = LoadUnitHandle(bj_lastCreatedHashtable,GetHandleId(t),1)
    call RemoveUnit(u)
    call DestroyTimer(t)
    set u = null
    set t = null
endfunction

function UR takes unit u, real r returns nothing
    local timer t = CreateTimer()
    call SaveUnitHandle(bj_lastCreatedHashtable,GetHandleId(t),1,u)
    call TimerStart(t,r,false,function UR_Action)
    set t = null
    set u = null
endfunction

// CallBackHash
function timerCreate takes nothing returns nothing
set udg_t = CreateTimer()
endfunction

function timerstart takes trigger a,real c , boolean b  returns nothing
call TriggerRegisterTimerExpireEventBJ( a, udg_t )
call TimerStart(udg_t, c, b, null)
endfunction

function TimerExpired takes nothing returns nothing
set udg_t = GetExpiredTimer()
endfunction

function TimerEnd takes nothing returns nothing
call FlushChildHashtable(udg_CallBackHash ,GetHandleId(udg_t))
call DestroyTimer(udg_t)
endfunction

function ASaveInteger takes integer order,integer Value returns nothing 
call SaveInteger(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function BSaveReal takes integer order,real Value returns nothing 
call SaveReal(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function CSaveBoolean takes integer order,boolean Value returns nothing 
call SaveBoolean(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function DSaveStr takes integer order,string Value returns nothing 
call SaveStr(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function ESavePlayer takes integer order,player Value returns nothing 
call SavePlayerHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function FSaveWidget takes integer order,widget Value returns nothing 
call SaveWidgetHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function GSaveDestructable takes integer order,destructable Value returns nothing 
call SaveDestructableHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function HSaveItem takes integer order,item Value returns nothing 
call SaveItemHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function ISaveUnit takes integer order,unit Value returns nothing 
call SaveUnitHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function JSaveTimer takes integer order,timer Value returns nothing 
call SaveTimerHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function KSaveTrigger takes integer order,trigger Value returns nothing 
call SaveTriggerHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function LSaveForce takes integer order,force Value returns nothing 
call SaveForceHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function NSaveGroup takes integer order,group Value returns nothing 
call SaveGroupHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function MSaveLocation takes integer order,location Value returns nothing 
call SaveLocationHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function OSaveRect takes integer order,rect Value returns nothing 
call SaveRectHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function PSaveEffect takes integer order,effect Value returns nothing 
call SaveEffectHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function RSaveTextTag takes integer order,texttag Value returns nothing 
call SaveTextTagHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction
function SSaveLightning takes integer order,lightning Value returns nothing 
call SaveLightningHandle(udg_CallBackHash,GetHandleId(udg_t),order,Value)
endfunction

function asaveInteger takes integer order returns integer
return(LoadInteger(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function bsaveReal takes integer order returns real
return(LoadReal(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function csaveBoolean takes integer order returns boolean
return(LoadBoolean(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function dsaveStr takes integer order returns string
return(LoadStr(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function esavePlayer takes integer order returns player
return(LoadPlayerHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function fsaveWidget takes integer order returns widget
return(LoadWidgetHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function gsaveDestructable takes integer order returns destructable 
return(LoadDestructableHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function hsaveItem takes integer order returns item
return(LoadItemHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function isaveUnit takes integer order returns unit
return(LoadUnitHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function jsaveTimer takes integer order returns timer
return(LoadTimerHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function ksaveTrigger takes integer order returns trigger
return(LoadTriggerHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function lsaveForce takes integer order returns force
return(LoadForceHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function nsaveGroup takes integer order returns group
return(LoadGroupHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function msaveLocation takes integer order returns location
return(LoadLocationHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function osaveRect takes integer order returns rect
return(LoadRectHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function psaveEffect takes integer order returns effect
return(LoadEffectHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function rsaveTextTag takes integer order returns texttag
return(LoadTextTagHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction
function ssaveLightning takes integer order returns lightning 
return(LoadLightningHandle(udg_CallBackHash,GetHandleId(udg_t),order))
endfunction

function IsPointPathableEx takes location WhereLoc returns boolean
    local boolean CheckLoc
    local real x
    local real y
    local real ix
    local real iy
    local item DummyItem = CreateItem('cnob',-2048,2048)
    set x = GetLocationX(WhereLoc)
    set y = GetLocationY(WhereLoc)
    call SetItemVisible(DummyItem,false)
    call SetItemPosition(DummyItem,x,y)
    set ix = GetItemX(DummyItem)
    set iy = GetItemY(DummyItem)
    set CheckLoc = (x - ix) * (x - ix) + (y - iy) * (y- iy) <=20.00
    call SetItemVisible(DummyItem,false)
    call RemoveItem(DummyItem)
    set DummyItem = null
    return CheckLoc
endfunction

    
    // 사용가능 구역인지 확인 
    function getAccessibility takes location loc returns boolean
        // location이 해당 구역에 포함되면 false를 반환한다 
        if ( RectContainsLoc(gg_rct_systemzone, loc) == true ) then
            return false
        //elseif ( RectContainsLoc(gg_rct_votearea, loc) == true ) then
        //    return false
        //elseif ( RectContainsLoc(gg_rct_Water1, loc) == true ) then
        //    return false
        elseif ( RectContainsLoc(gg_rct_Water2, loc) == true ) then
            return false
        elseif ( RectContainsLoc(gg_rct_Water3, loc) == true ) then
            return false
        elseif ( RectContainsLoc(gg_rct_Water4, loc) == true) then
            return false
        elseif ( RectContainsLoc(gg_rct_Water5, loc) == true) then
            return false
        elseif ( RectContainsLoc(gg_rct_Water6, loc) == true) then
            return false
        elseif ( RectContainsLoc(gg_rct_Water7, loc) == true) then
            return false
        elseif ( RectContainsLoc(gg_rct_Water8, loc) == true) then
            return false
            
        // filed
        elseif (RectContainsLoc(gg_rct_Fild1, loc) == true) then
            return true
        elseif ( RectContainsLoc(gg_rct_FieldSchool, loc) == true ) then
            return true
        elseif ( RectContainsLoc(gg_rct_FieldSubway, loc) == true ) then
           return true
        elseif ( RectContainsLoc(gg_rct_FieldLeft, loc) == true ) then
           return true
        elseif ( RectContainsLoc(gg_rct_TokiwadaiField, loc) == true ) then
            return true
        elseif ( RectContainsLoc(gg_rct_FieldUnderstair, loc) == true ) then
            return true
        elseif ( RectContainsLoc(gg_rct_RectPublicBath, loc) == true ) then
            return true
        else
            return false
        endif
    endfunction

    function isItem takes nothing returns boolean
        if ( ( GetSpellAbilityId() == 'AIre' or GetSpellAbilityId() == 'AIp3' or GetSpellAbilityId() == 'AIse' ) ) then
            return true
        endif
        if ( ( GetSpellAbilityId() == 'A03R' or GetSpellAbilityId() == 'A08N' or GetSpellAbilityId() == 'A09A' ) ) then
            return true
        endif
        if ( ( GetSpellAbilityId() == 'A0BA' or GetSpellAbilityId() == 'AIsw' or GetSpellAbilityId() == 'AIsa' ) ) then
            return true
        endif
        if ( ( GetSpellAbilityId() == 'A03S' or GetSpellAbilityId() == 'Aam2' or GetSpellAbilityId() == 'AIfr') ) then
            return true
        endif
        if ( ( GetSpellAbilityId() == 'AIbk' or GetSpellAbilityId() == 'Awfb') ) then
            return true
        endif
        return false
    endfunction

    // 우선도 계산 
    //     i : 컴퓨터 
    function calcPriority takes integer i returns unit
        local integer idx
        local integer end_idx
        local real distance 
        local real life
        local real point = 0
        local real max_point = 0
        local integer result_pid = 1
        local integer VisionStack = 0
        local location VisionLoc
        
        if i < 7 then
            set idx = 7
            set end_idx = 12
        else
            set idx = 1
            set end_idx = 6
        endif
        
        loop
            exitwhen idx > end_idx
            set point = 0
            if (IsUnitType(udg_Hero[idx], UNIT_TYPE_DEAD) == false and udg_Hero[idx] != null) then
                // 계산 Start
                if (UnitHasBuffBJ(udg_Hero[idx], 'B027') == false and GetUnitTypeId(udg_Hero[i]) != 'H01P') or (GetUnitTypeId(udg_Hero[i]) == 'H01P') then
                    if (AI_LEVEL[idx] > USER) then
                        set point = point - 100
                    else
                        set distance = DistanceBetweenUnits(udg_Hero[i], udg_Hero[idx])
                        if (distance < 2000) then
                            if distance > 700 then
                                set point = point + (300 - (distance/25))
                            else
                                set point = point + (300 - (distance/10))
                            endif
                        else
                            set point = point + 8 + GetRandomReal(1.0, 6.0)
                        endif
                    endif

                    // 시야에 노출되었는지 체크 
                    if (IsUnitVisible(udg_Hero[idx], GetOwningPlayer(udg_Hero[i])) == true) then
                        set point = point + 250
                    else 
                        set point = point - 25
                        set VisionStack = VisionStack + 1
                    endif
                
                    // status check
                    if (udg_FuseStart[idx] == true) then
                        set point = point + 1
                    elseif (udg_FuseCooldown[idx] > 0) then
                        set point = point + 250
                    else
                        set point = point + 50
                    endif
                
                    // 체력 절대치 체크 
                    set life = GetUnitStateSwap(UNIT_STATE_LIFE, udg_Hero[idx])
                    if (life  < 200) then
                        set point = point + 250
                    elseif (life < 490) then
                        set point = point + 100
                    else
                        set point = point + 10
                    endif
                    
                    // Rua Check 
                    if (UnitHasBuffBJ(udg_Hero[idx], 'B00G') == false) then
                        set point = point + 75
                    else
                        set point = point - 75
                    endif                    
                else
                    set point = -100
                endif
            else
                set point = 0
            endif
            
            //call BJDebugMsg(I2S(idx) + "player point : " + R2S(point))
            if point >= max_point then
                set max_point = point + 0
                set result_pid = idx
            endif
                
            set idx = idx + 1
        endloop
        
        // 유저 추적
        //if VisionStack > 3 and GetUnitLevel(udg_Hero[result_pid]) > 15 and GetRandomInt(0,2) == 1 then
        //    set VisionLoc = GetUnitLoc(udg_Hero[result_pid])
        //    call CreateUnitAtLoc(GetOwningPlayer(udg_Hero[i]), 'h01T', VisionLoc, 0.0)
        //  call RemoveLocation(VisionLoc)
        //  set VisionLoc = null
        //endif
        
        //call BJDebugMsg("result : " + I2S(result_pid))
        return udg_Hero[result_pid]
    endfunction
    
    // 1퓨즈 또는  castingToAi 에서 사용  
    function setTarget takes integer i returns nothing
        // 컴퓨터가 아닐경우 건너뜀 
        if (udg_Hero[i] != null and AI_LEVEL[i] != USER) then
            set udg_targetofai[i] = calcPriority(i)
        endif
    endfunction

    
    // fuse teleport    
    function cTellpo2 takes unit target, integer i returns nothing
        local location loc
        local location targetLoc
        local real dist
        local boolean isAccessible
        
        // 액셀이 일방통행 상태일 때 + Touma가 아님 
        if (UnitHasBuffBJ(target, 'B027') == true and GetUnitTypeId(udg_Hero[i]) != 'H01P') then
            set udg_targetofai[i] = null
            call setTarget(i)
            set target = udg_targetofai[i]
        endif
        
        if (uStateCheck(target, udg_Hero[i]) == true) and (IsUnitPausedBJ(udg_Hero[i]) == false)  then          
            if (udg_FuseStart[i] == false) then
                set udg_FuseCooldown[i] = 6
            endif
            // 거리 체크 
            set loc = GetUnitLoc(target)
            call SetUnitManaPercentBJ( udg_Hero[i], 100 )
            call UnitResetCooldown( udg_Hero[i] )
            // tsuchi, aqua, kakine
            if (GetUnitTypeId(udg_Hero[i]) == 'H004' or GetUnitTypeId(udg_Hero[i]) == 'H009' or GetUnitTypeId(udg_Hero[i]) == 'H00R' or GetUnitTypeId(udg_Hero[i]) == 'H00B') then
                set targetLoc = PolarProjectionBJ(loc, 750, GetUnitFacing(target))
                set isAccessible = getAccessibility(targetLoc)                
                if (isAccessible == true) then
                    call SetUnitPositionLoc( udg_Hero[i], targetLoc )
                else
                    call SetUnitPositionLoc( udg_Hero[i], loc )
                endif
                call AddSpecialEffectTargetUnitBJ( "origin", udg_Hero[i], "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl" )
                call DestroyEffectBJ( GetLastCreatedEffectBJ() )
            // mugino
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H02I') then
                set targetLoc = PolarProjectionBJ(loc, 1300, GetRandomDirectionDeg())
                set isAccessible = getAccessibility(targetLoc)
                if (isAccessible == true) then
                    call SetUnitPositionLoc( udg_Hero[i], targetLoc )
                    call AddSpecialEffectTargetUnitBJ( "origin", udg_Hero[i], "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl" )
                    call DestroyEffectBJ( GetLastCreatedEffectBJ() )
                endif
            // accel
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H000' or GetUnitTypeId(udg_Hero[i]) == 'H01J') then
                if (udg_AccPenalty == false) then
                    call SetUnitPositionLoc( udg_Hero[i], loc )
                    call AddSpecialEffectTargetUnitBJ( "origin", udg_Hero[i], "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl" )
                    call DestroyEffectBJ( GetLastCreatedEffectBJ() )
                    call TriggerExecute( gg_trg_AccC )
                    call RemoveLocation(loc)
                else
                    set targetLoc = PolarProjectionBJ(loc, 1400, GetRandomDirectionDeg())
                    set isAccessible = getAccessibility(targetLoc)
                    if (isAccessible == true) then
                        call SetUnitPositionLoc( udg_Hero[i], targetLoc )
                        call AddSpecialEffectTargetUnitBJ( "origin", udg_Hero[i], "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl" )
                        call DestroyEffectBJ( GetLastCreatedEffectBJ() )
                    endif
                    call RemoveLocation(loc)
                    call RemoveLocation(targetLoc)
                endif
                set targetLoc = null         
                set loc = null
                return
            else
                set targetLoc = PolarProjectionBJ(loc, -230, GetUnitFacing(target))
                set isAccessible = getAccessibility(targetLoc)
                if (isAccessible == false) then
                    call RemoveLocation(targetLoc)
                    set targetLoc = GetUnitLoc(target)
                endif
                call SetUnitPositionLoc( udg_Hero[i], targetLoc )
                call AddSpecialEffectTargetUnitBJ( "origin", udg_Hero[i], "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl" )
                call DestroyEffectBJ( GetLastCreatedEffectBJ() )
            endif
            
            // attack
            call UnitUseItem(udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I017'))
            call TriggerSleepAction( 0.10 )
            //call AddSpecialEffectTargetUnitBJ( "origin", udg_Hero[i], "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl" )
            //call DestroyEffectBJ( GetLastCreatedEffectBJ() )
            
            set dist = DistanceBetweenUnits(target, udg_Hero[i])
            if (GetUnitTypeId(udg_Hero[i]) == 'H01P' or GetUnitTypeId(udg_Hero[i]) == 'H002') then
                if (GetUnitTypeId(udg_Hero[i]) == 'H01P' and GetHeroLevel(udg_Hero[i]) > 12 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                    call TriggerExecute( gg_trg_KamiF2 )
                    call TriggerSleepAction(1.0)
                    call TriggerExecute( gg_trg_KamiF )
                endif
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call TriggerSleepAction( 0.10 )
                call IssueTargetOrder( udg_Hero[i], "thunderbolt", target )  
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H016') then
                call IssueImmediateOrder( udg_Hero[i], "stomp")
                call thunderBolt(udg_Hero[i], target)
                if ( GetHeroLevel(udg_Hero[i]) > 14 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                    call TriggerExecute( gg_trg_SogiF )
                elseif AI_LEVEL[i] == INSANE and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) < 120.00 then
                    call TriggerExecute(gg_trg_SogiG)
                endif
                call TriggerSleepAction(0.1)
                call IssueTargetOrder( udg_Hero[i], "thunderbolt", target )
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H02Y') then
                call thunderBolt(udg_Hero[i], target)
                call CreateUnitAtLoc(GetOwningPlayer(udg_Hero_Misaki), 'hgyr', loc, 0.0)
                call UnitApplyTimedLifeBJ( 60, 'BFig', GetLastCreatedUnit())
                call IssueImmediateOrder( udg_Hero[i], "windwalk")
                call TriggerSleepAction( 0.30 )
                call IssueImmediateOrder( udg_Hero[i], "tranquility")
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H004') then
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call PlaySoundBJ( gg_snd_red0 )
                call TriggerSleepAction( 0.10 )                
                call IssuePointOrderLocBJ( udg_Hero[i], "clusterrockets", loc)                                        
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H02I') then
                if (GetHeroLevel(udg_Hero[i]) > 14 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                    call TriggerExecute( gg_trg_MugiE )
                else
                    call IssuePointOrderLoc( udg_Hero[i], "carrionswarm", loc)
                endif
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H01Q') then
                set udg_MisaCeLoc = GetUnitLoc(target)
                if (GetHeroLevel(udg_Hero[i]) > 10 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                    call TriggerExecute( gg_trg_MisaE )
                endif
                call CreateNUnitsAtLoc( 1, 'h035', GetOwningPlayer(udg_Hero[i]), udg_MisaCeLoc, bj_UNIT_FACING )
                call SetPlayerAbilityAvailableBJ( false, 'A0BU', GetOwningPlayer(udg_Hero[i]) )
                call StartTimerBJ( udg_MisaCeT2, false, 3.80 )
                call StartTimerBJ( udg_MisaCeT, false, 0.80 )
                call TriggerSleepAction(0.1)
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call TriggerSleepAction(0.1)            
                call IssueImmediateOrder( udg_Hero[i], "thunderclap")  
                call TriggerSleepAction(0.1)
                call IssueTargetOrder( udg_Hero[i], "deathcoil", target )
                call thunderBolt(udg_Hero[i], target)
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H02P') then
                call TriggerExecute( gg_trg_IndexB1 )
                call thunderBolt(udg_Hero[i], target)
                call UnitAddItemByIdSwapped( 'I007', udg_Hero[i] )
                call IssueImmediateOrder( udg_Hero[i], "fanofknives")
                call TriggerExecute( gg_trg_IndexB1 )
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H009') then
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call TriggerSleepAction( 0.10 )
                call IssuePointOrderLocBJ( udg_Hero[i], "clusterrockets", loc)
                if GetHeroLevel(udg_Hero[i]) > 14 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00 then
                    call TriggerExecute( gg_trg_AquaE )
                endif
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H006') then                
                set udg_KuroCTarget = GetUnitLoc(target)
                call CreateNUnitsAtLoc( 1, 'h00Q', GetOwningPlayer(udg_KuroHero), udg_KuroCTarget, bj_UNIT_FACING )
                call PlaySoundBJ( gg_snd_teleport )
                call StartTimerBJ( udg_KuroCTimer, false, 0.40 )
                call TriggerSleepAction( 1.00 )
                set dist = DistanceBetweenUnits(target, udg_Hero[i])
                if IsUnitType(udg_Hero[i], UNIT_TYPE_DEAD) == false and dist < 1100 then
                    if GetHeroLevel(udg_Hero[i]) > 14 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00 then
                        call CreateUnitAtLoc(GetOwningPlayer(udg_Hero[i]), 'nhef', loc, 0)
                        call TriggerSleepAction( 1.00 )
                        // 건붕 더미 
                        call SetUnitManaBJ( udg_TreatmentSys[i], 90.00 )
                        call CreateNUnitsAtLocFacingLocBJ( 1, 'h046', GetOwningPlayer(udg_Hero[i]), (loc),(loc))
                        call SetUnitFlyHeightBJ( GetLastCreatedUnit(), 0.00, 1500.00 )
                        call DestroyEffectBJ( AddSpecialEffectTarget("SandExplosion.mdx", GetLastCreatedUnit(), "origin") )                       
                    else
                        call timerCreate(  )
                        call ISaveUnit( 1, udg_Hero[i] )
                        call ISaveUnit( 2, target )
                        call timerstart( gg_trg_KuroD3, 0.15, true )
                    endif
                endif
                call RemoveLocation(udg_KuroCTarget)
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H00R' or GetUnitTypeId(udg_Hero[i]) == 'H00B') then                
                call CreateNUnitsAtLoc( 1, 'h00F', GetOwningPlayer(udg_Hero[i]), loc, bj_UNIT_FACING )
                call SetUnitAbilityLevelSwapped( 'Aprg', GetLastCreatedUnit(), 1 )
                call IssueTargetOrderBJ( GetLastCreatedUnit(), "purge", target )
                if (GetHeroLevel(udg_Hero[i]) > 11 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                    call TriggerExecute( gg_trg_KakiE )
                    call SetUnitState(udg_TreatmentSys[GetConvertedPlayerId(GetOwningPlayer(udg_KakiHero))],UNIT_STATE_MANA,120.00)
                    call TriggerSleepAction( 0.10 )
                endif                
                call IssuePointOrderLocBJ( udg_Hero[i], "clusterrockets", loc)
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H007') then
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call thunderBolt(udg_Hero[i], target)
                call TriggerExecute( gg_trg_StiylD )
                if (GetHeroLevel(udg_Hero[i]) > 10 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                    call TriggerExecute( gg_trg_StiylF )
                endif
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H041') then
                set dist = DistanceBetweenUnits(target, udg_Hero[i])
                if dist < 1100 then
                    set udg_FrendaL[2] = GetUnitLoc(target)
                    call TriggerExecute( gg_trg_Fren41 ) 
                endif
                call TriggerSleepAction( 0.75 )
                set dist = DistanceBetweenUnits(target, udg_Hero[i])
                if dist < 1200 then
                    call CreateNUnitsAtLoc( 1, 'n00Q', GetOwningPlayer(udg_FrendaU[0]),(loc), bj_UNIT_FACING )
                    call KillUnit(GetLastCreatedUnit())   
                endif
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H03C') then 
                call IssuePointOrderLocBJ( udg_Hero[i], "summonfactory", loc)
                call thunderBolt(udg_Hero[i], target)         
                call TriggerSleepAction( 0.3 )
                call IssueImmediateOrder( udg_Hero[i], "stomp")
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H04T') then
                // r
                set dist = DistanceBetweenUnits(target, udg_Hero[i])
                if dist < 1200 then
                    set udg_BirdL[9] = GetUnitLoc(target)
                    call StartTimerBJ( udg_BirdT[2], false, ( 2.00 + udg_BirdOpt5 ) )
                    call StartTimerBJ( udg_BirdT[3], true, ( 0.40 - ( 0.04 * I2R(GetUnitAbilityLevelSwapped('A0HM', udg_BirdU[0])) ) ) )
                endif
                call TriggerSleepAction( 0.75 )
                set dist = DistanceBetweenUnits(target, udg_Hero[i])
                if dist < 1200 then
                    // e-r
                    call timerCreate(  )
                    call ASaveInteger( 0, 0 )
                    call timerstart( gg_trg_Bird321, 0.03, true )
                    set udg_BirdU[4] = target
                endif
                call TriggerSleepAction( 0.75 )
                set dist = DistanceBetweenUnits(target, udg_Hero[i])
                if dist < 1200 then
                    call thunderBolt(udg_Hero[i], target)
                    if (GetHeroLevel(udg_Hero[i]) > 14 and GetUnitStateSwap(UNIT_STATE_MANA, udg_TreatmentSys[i]) == 0.00) then
                        call TriggerExecute( gg_trg_Bird501 )
                        call TriggerSleepAction(1.0)
                        call TriggerExecute( gg_trg_Bird500 )
                    endif
                endif
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H02R') then
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call TriggerSleepAction( 0.1 )
                call IssuePointOrderLocBJ( udg_Hero[i], "carrionswarm", loc)
                call TriggerSleepAction( 1.25 )
                call thunderBolt(udg_Hero[i], target)
                call IssueTargetOrderBJ( udg_Hero[i], "thunderbolt", target )                
            elseif (GetUnitTypeId(udg_Hero[i]) == 'H02U') then
                set udg_VentNum = 10
                call SetItemCharges( GetItemOfTypeFromUnitBJ(udg_Hero_Vent, 'I012'), udg_VentNum )
                call UnitUseItemTarget( udg_Hero[i], GetItemOfTypeFromUnitBJ(udg_Hero[i], 'I00P'), target )
                call TriggerSleepAction( 0.10 )
                call IssueTargetOrder( udg_Hero[i], "frostnova", target )
                if GetHeroLevel(udg_Hero[i]) > 12 then
                    call TriggerExecute( gg_trg_VentF )
                endif
            elseif ( GetUnitTypeId(udg_Hero[i]) == 'H02T' ) then
                call IssueImmediateOrder( udg_Hero[i], "roar")
                set udg_HeroAbillityKLEEUnit = udg_targetofai[i]
                set udg_KL_R = GetUnitLoc(udg_targetofai[i])
                if KLActiveCheck == false then
                    call TriggerExecute(gg_trg_KLRW)
                endif
                call UnitAddItemByIdSwapped( 'I007', udg_Hero[i] )
            endif
            
            call SetItemCharges( GetItemOfTypeFromUnitBJ(udg_TreatmentSys[i], 'I006'), ( GetItemCharges(GetItemOfTypeFromUnitBJ(udg_TreatmentSys[i], 'I006')) - 3 ) )
            call RemoveLocation(targetLoc)
            call RemoveLocation(loc)
            set targetLoc = null
            set target = null            
            set loc = null
        endif
    endfunction
    
