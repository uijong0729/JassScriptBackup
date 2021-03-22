library CommonLib
    globals
        constant integer STAT_POINT = 'I005'
        constant integer FUSE_POINT = 'I006'
        constant integer DIVINE_POINT = 'I00W'
        constant integer STAT_POINT_DAMAGE = 'R000'
        constant integer STAT_POINT_ARMOR = 'R001'
        constant integer STAT_POINT_MOVESPEED = 'R002'
        constant integer STAT_POINT_HP_REGEN = 'R003'
        constant integer STAT_POINT_MP_REGEN = 'R004'
        constant string HEAVEN_HASH_KEY = "HeadDeadLocation"
        constant integer HERO = 0
        constant integer DUMMY1 = 1
        constant integer DUMMY2 = 2
    endglobals
    
    // 지역이동 조건 
    function MovableBldg takes nothing returns boolean
        return IsUnitPausedBJ(GetTriggerUnit()) == false and GetUnitUserData(GetTriggerUnit()) != 100 and (GetUnitPointValue(GetTriggerUnit()) == 99 or GetUnitPointValue(GetTriggerUnit()) == 96)
    endfunction
    
    // 지역이동 
    function MoveToXY takes unit u, real x, real y returns nothing
        call SetUnitPosition( u, x, y )
        call PanCameraToTimedForPlayer( GetOwningPlayer(u), x, y, 0 )
    endfunction

    // 속성 습득 사운드 재생  
    function ReinSound takes nothing returns nothing
        if ( GetOwningPlayer(GetTriggerUnit()) == GetLocalPlayer() ) then
            call PlaySoundBJ( gg_snd_Absound4 )
        endif
    endfunction
    
    //Treatment Only 속성습득 조건체크
    function ConsumeStat takes integer point returns boolean
        local item it = GetItemOfTypeFromUnitBJ(GetTriggerUnit(), STAT_POINT)
        local integer stack = GetItemCharges(it)
        if stack >= point then
            call SetItemCharges( it, ( stack - point ) )
            if ( GetOwningPlayer(GetTriggerUnit()) == GetLocalPlayer() ) then
                call PlaySoundBJ( gg_snd_Absound4 )
            endif
            return true
        else
            call DisplayTextToForce( GetForceOfPlayer(GetOwningPlayer(GetTriggerUnit())), "TRIGSTR_015" )
            return false
        endif
    endfunction
       
    function SogiET takes nothing returns nothing
        local integer i = GetConvertedPlayerId(GetOwningPlayer(udg_SogiHero))
        local integer itemidx
        if udg_SogiHero != null then
            set itemidx = GetItemCharges(GetItemOfTypeFromUnitBJ(udg_TreatmentSys[i], 'afac'))
            if ( itemidx >= 1 ) then
                call SetItemCharges( GetItemOfTypeFromUnitBJ(udg_TreatmentSys[i], 'afac'), ( itemidx - 1 ) )
            endif
        else
            call DestroyTimer(GetExpiredTimer())
        endif    
    endfunction

    function SogiE takes nothing returns nothing
        local timer t = CreateTimer()
        call TimerStart(t, 1.0, true, function SogiET)
        set t = null
    endfunction
endlibrary
