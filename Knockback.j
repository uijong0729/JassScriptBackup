library KBLib requires TimerUtils    
    globals
        constant integer POINT_CREEP = 333
        constant integer POINT_WARD = 444
        constant integer POINT_HERO = 99
    endglobals
    struct KB extends array
        static constant real TIMEOUT = .02 /* 주기 (낮을수록 자연스럽지만 렉이 심해짐) (0.02~0.03이 적당) */
        static constant real GRAVITY = .6
        static integer stack = 0
        thistype recycle
        unit unit
        integer c
        real cos
        real sin
        // 추가 변수 : para 관련 
        integer istack
        integer ic
        // 추가 변수 : colision 관련 
        group g
        real radius
        real damage
        integer effectDumId
        
    private static method getAccess takes unit u returns boolean
        // location이 해당 구역에 포함되면 false를 반환한다 
        if ( RectContainsUnit(gg_rct_systemzone, u) == true ) then
            return false
        // filed
        elseif (RectContainsUnit(gg_rct_Fild1, u) == true) then
            return true
        elseif ( RectContainsUnit(gg_rct_FieldSchool, u) == true ) then
            return true
        elseif ( RectContainsUnit(gg_rct_FieldSubway, u) == true ) then
           return true
        elseif ( RectContainsUnit(gg_rct_FieldLeft, u) == true ) then
           return true
        elseif ( RectContainsUnit(gg_rct_TokiwadaiField, u) == true ) then
            return true
        elseif ( RectContainsUnit(gg_rct_FieldUnderstair, u) == true ) then
            return true
        elseif ( RectContainsUnit(gg_rct_RectPublicBath, u) == true ) then
            return true
        else
            return false
        endif
    endmethod
    
        private static method colPeriod takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            local unit target = null
            local boolean isExit = false
            set .c = .c - 1
            if getAccess(.unit) == true then
                call SetUnitPosition(.unit, GetUnitX(.unit) + .cos, GetUnitY(.unit) + .sin)
            endif
            call GroupEnumUnitsInRange(.g, GetUnitX(.unit), GetUnitY(.unit), .radius, null)            
            if CountUnitsInGroup(.g) > 0 then
                loop 
                    if (isExit == false) then
                        set target = FirstOfGroup(.g)
                    else 
                        set target = null
                    endif
                    exitwhen target == null
                    if IsUnitEnemy(target, GetOwningPlayer(.unit)) == true and IsUnitType(target, UNIT_TYPE_DEAD) == false and GetUnitPointValue(target) != POINT_WARD then
                        if (.effectDumId != 0) then
                            call CreateUnit(GetOwningPlayer(.unit), .effectDumId, GetUnitX(.unit), GetUnitY(.unit), GetUnitFacing(.unit))
                        endif
                        if GetUnitTypeId(.unit) == 'hwt2'  then
                            if GetUnitPointValue(target) == POINT_HERO then
                                set .c = 0
                                set isExit = true
                                // damage 1/2
                                if (IsUnitType(target, UNIT_TYPE_ANCIENT) == true) then
                                    set .damage = .damage / 2
                                endif
                            endif
                        elseif GetUnitTypeId(.unit) == 'hwt2' then
                            // damage 1/2
                            if (IsUnitType(target, UNIT_TYPE_ANCIENT) == true) then
                                set .damage = .damage / 2
                            endif
                            set .c = 0
                            set isExit = true
                        else
                            set .c = 0
                            set isExit = true
                        endif
                        call UnitDamageTarget(.unit, target, .damage, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                    endif
                    call GroupRemoveUnit(.g, target)
                endloop
            endif            
            
            if .c < 1 then
                set this.recycle = thistype(0).recycle
                set thistype(0).recycle = this
                call ReleaseTimer(GetExpiredTimer())
                call DestroyGroup(.g)
                call KillUnit(.unit)
                set target = null
            endif
        endmethod
        
        static method startColision takes unit u, real d, real a, real dur, real rad, real dmg, integer dumid returns nothing
            local thistype this

            if thistype(0).recycle == 0 then
                set stack = stack + 1
                set this = stack
            else
                set this = thistype(0).recycle
                set thistype(0).recycle = thistype(0).recycle.recycle
            endif
            
            set .unit = u
            set .g = CreateGroup()
            set .radius = rad
            set .damage = dmg
            set .c = R2I(dur / TIMEOUT)
            set .effectDumId = dumid
            
            if .c < 1 then
                set .c = 1
            endif
            
            set d = d / .c
            set .cos = d * Cos(a)
            set .sin = d * Sin(a)
            
            call TimerStart(NewTimerEx(this), TIMEOUT, true, function thistype.colPeriod)
        endmethod
        
        private static method periodic takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            set .c = .c - 1
            call SetUnitPosition(.unit, GetUnitX(.unit) + .cos, GetUnitY(.unit) + .sin)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", .unit, "origin"))
            if .c < 1 then
                set this.recycle = thistype(0).recycle
                set thistype(0).recycle = this
                call ReleaseTimer(GetExpiredTimer())
            endif
        endmethod
        
        static method start takes unit u, real d, real a, real dur returns nothing
            local thistype this

            if thistype(0).recycle == 0 then
                set stack = stack + 1
                set this = stack
            else
                set this = thistype(0).recycle
                set thistype(0).recycle = thistype(0).recycle.recycle
            endif
            
            set .unit = u
            set .c = R2I(dur / TIMEOUT)
            
            if .c < 1 then
                set .c = 1
            endif
            
            set d = d / .c
            set .cos = d * Cos(a)
            set .sin = d * Sin(a)
            
            call TimerStart(NewTimerEx(this), TIMEOUT, true, function thistype.periodic)
        endmethod
        
        // 포물선 period
        private static method periodicPara takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            set .c = .c - 1
            set .istack = .istack + 1
            call SetUnitPosition(.unit, GetUnitX(.unit) + .cos, GetUnitY(.unit) + .sin)
            if .c > .ic then
                call SetUnitFlyHeight(.unit, .istack*15, 0)
            else
                call SetUnitFlyHeight(.unit, (.ic-.istack)*21, 0)
            endif
            if .c < 1 then
                set this.recycle = thistype(0).recycle
                set thistype(0).recycle = this
                call SetUnitFlyHeight(.unit, 0, 0)
                call ReleaseTimer(GetExpiredTimer())                
            endif
        endmethod
        
        // 포물선 start 
        static method startPara takes unit u, real d, real a, real dur returns nothing
            local thistype this
            if thistype(0).recycle == 0 then
                set stack = stack + 1
                set this = stack
            else
                set this = thistype(0).recycle
                set thistype(0).recycle = thistype(0).recycle.recycle
            endif
            
            set .unit = u
            set .c = R2I(dur / TIMEOUT)
            set .ic = R2I(I2R(.c) * 0.6)
            
            if .c < 1 then
                set .c = 1
                set .ic = 0
            endif
            
            set d = d / .c
            set .cos = d * Cos(a)
            set .sin = d * Sin(a)
            set istack = 0
            
            // Crow Form
            call UnitAddAbility(.unit,'Arav')
            call UnitRemoveAbility(.unit,'Arav')
            call TimerStart(NewTimerEx(this), TIMEOUT, true, function thistype.periodicPara)
        endmethod
        
                private static method periodicPathCheck takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            set .c = .c - 1
            if getAccess(.unit) == true then
                call SetUnitPosition(.unit, GetUnitX(.unit) + .cos, GetUnitY(.unit) + .sin)
            endif
            if .c < 1 then
                set this.recycle = thistype(0).recycle
                set thistype(0).recycle = this
                call ReleaseTimer(GetExpiredTimer())
            endif
        endmethod
        
        static method startPathCheck takes unit u, real d, real a, real dur returns nothing
            local thistype this

            if thistype(0).recycle == 0 then
                set stack = stack + 1
                set this = stack
            else
                set this = thistype(0).recycle
                set thistype(0).recycle = thistype(0).recycle.recycle
            endif
            
            set .unit = u
            set .c = R2I(dur / TIMEOUT)
            
            if .c < 1 then
                set .c = 1
            endif
            
            set d = d / .c
            set .cos = d * Cos(a)
            set .sin = d * Sin(a)
            
            call TimerStart(NewTimerEx(this), TIMEOUT, true, function thistype.periodicPathCheck)
        endmethod
    endstruct
    

        
    /* call Knockback(시전자, 넉백할 대상, 넉백할 거리, 넉백 지속시간) 
       시전자 = 유닛
       넉백할 대상 = 유닛
       넉백할 거리 = 숫자 (실수)
       넉백 지속시간 = 숫자 (실수)
       
       예: Knockback(A, B, 300, 0.5)
       A가 B를 0.5초동안 300거리 밀어냄 */
    function Knockback takes unit source, unit target, real dist, real runtime returns nothing
        call KB.start(target, dist, Atan2(GetUnitY(target) - GetUnitY(source), GetUnitX(target) - GetUnitX(source)), runtime)
    endfunction
    
    function KnockbackPathCheck takes unit source, unit target, real dist, real runtime returns nothing
        call KB.startPathCheck(target, dist, Atan2(GetUnitY(target) - GetUnitY(source), GetUnitX(target) - GetUnitX(source)), runtime)
    endfunction

    /* call Knockback2(시전자, 넉백할 그룹, 넉백할 거리, 넉백 지속시간) 
       시전자 = 유닛
       넉백할 그룹 = 그룹
       넉백할 거리 = 숫자 (실수)
       넉백 지속시간 = 숫자 (실수)
       
       예: Knockback(A, G, 300, 0.5)
       A가 G의 유닛들을 0.5초동안 300거리 밀어냄 */
    function Knockback2 takes unit source, group targets, real dist, real runtime returns nothing
        local boolean wantDestroyGroup = bj_wantDestroyGroup
        local unit f
        
        set bj_wantDestroyGroup = false
        loop
            set f = FirstOfGroup(targets)
            exitwhen f == null
            call GroupRemoveUnit(targets, f)
            call Knockback(source, f, dist, runtime)
        endloop
        
        if wantDestroyGroup then
            call DestroyGroup(targets)
        endif
        set f = null
    endfunction

    /* call Knockback3(대상 지점, 넉백할 대상, 넉백할 거리, 넉백 지속시간) 
       대상 지점 = 지점
       넉백할 대상 = 유닛
       넉백할 거리 = 숫자 (실수)
       넉백 지속시간 = 숫자 (실수)
       
       예: Knockback(L, B, 300, 0.5)
       B를 L로부터 0.5초동안 300거리 밀어냄
       (L에서 B까지의 각도니, L으로부터 거리만큼 밀려나감)*/
    function Knockback3 takes location source, unit target, real dist, real runtime returns nothing
        call KB.start(target, dist, Atan2(GetUnitY(target) - GetLocationY(source), GetUnitX(target) - GetLocationX(source)), runtime)
    endfunction
    
    function KnockbackPara takes unit source, unit target, real dist, real runtime returns nothing
        call KB.startPara(target, dist, Atan2(GetUnitY(target) - GetUnitY(source), GetUnitX(target) - GetUnitX(source)), runtime)
    endfunction
    
    function KnockbackColision takes unit source, unit target, real dist, real runtime, real radius, real dmg, integer dumid returns nothing
        call KB.startColision(target, dist, Atan2(GetUnitY(target) - GetUnitY(source), GetUnitX(target) - GetUnitX(source)), runtime, radius, dmg, dumid)
    endfunction
endlibrary