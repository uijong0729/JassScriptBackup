function exitBldg takes unit target, unit me returns nothing
    if ( RectContainsUnit(gg_rct_FieldSchool, me) == true ) then
        call IssuePointOrder(me, "attack", 6000.0, 9403.00)
    elseif ( RectContainsUnit(gg_rct_FieldSubway, me) == true ) then        
        if RectContainsUnit(gg_rct_SubwayExitRec2, target) == true then
            call IssuePointOrder(me, "attack", -357.00, 9831.00)
        elseif RectContainsUnit(gg_rct_SubwayExitRec1, target) == true then
            call IssuePointOrder(me, "attack", -346.00, 11032.00)
        elseif RectContainsUnit(gg_rct_SubwayExitRec3, target) == true then
            call IssuePointOrder(me, "attack", 2852.00, 11063.00)
        elseif RectContainsUnit(gg_rct_SubwayExitRec4, target) == true then
            call IssuePointOrder(me, "attack", 2849.00, 9832.00)
        endif
    elseif ( RectContainsUnit(gg_rct_FieldLeft, me) == true ) then
        call IssuePointOrder(me, "attack", -11470.00, 10775.00)
    elseif ( RectContainsUnit(gg_rct_TokiwadaiField, me) == true ) then
        call IssuePointOrder(me, "attack", -11489.00, 2127.00)
    elseif ( RectContainsUnit(gg_rct_FieldUnderstair, me) == true ) then
        call IssuePointOrder(me, "attack", -10127.00, -5287.00)
    elseif ( RectContainsUnit(gg_rct_RectPublicBath, me) == true ) then
        call IssuePointOrder(me, "attack", -6586.00, 11157.00)
    endif
endfunction

function enterBldg takes unit target, unit me returns nothing
    if ( RectContainsUnit(gg_rct_FieldSchool, target) == true ) then
        call IssuePointOrder(me, "attack", 5664.00, -210.00)
    elseif ( RectContainsUnit(gg_rct_FieldSubway, target) == true ) then
        if RectContainsUnit(gg_rct_SubwayExitRec2, me) == true then
            call IssuePointOrder(me, "attack", 261.00, -2708.00)
        elseif RectContainsUnit(gg_rct_SubwayExitRec1, me) == true then
            call IssuePointOrder(me, "attack", -3217, 893)
        elseif RectContainsUnit(gg_rct_SubwayExitRec3, me) == true then
            call IssuePointOrder(me, "attack", 6920, 2065)
        elseif RectContainsUnit(gg_rct_SubwayExitRec4, me) == true then
            call IssuePointOrder(me, "attack", 4138, -3088)
        endif
    elseif ( RectContainsUnit(gg_rct_FieldLeft, target) == true ) then
        call IssuePointOrder(me, "attack", 6481.00, -5296.00)
    elseif ( RectContainsUnit(gg_rct_TokiwadaiField, target) == true ) then
        call IssuePointOrder(me, "attack", -3516.00, -6497.00)
    elseif ( RectContainsUnit(gg_rct_FieldUnderstair, target) == true ) then
        call IssuePointOrder(me, "attack", 3923.00, -4617.00)
    elseif ( RectContainsUnit(gg_rct_RectPublicBath, target) == true ) then
        call IssuePointOrder(me, "attack", -2406.00, 4126.00)
    endif
endfunction

function isSameBldg takes unit target, unit me returns boolean
    if (RectContainsUnit(gg_rct_FieldSchool, target) == true and RectContainsUnit(gg_rct_FieldSchool, me) == true) then
        return true
    elseif ( RectContainsUnit(gg_rct_FieldSubway, target) == true and RectContainsUnit(gg_rct_FieldSubway, me) == true) then
        return true
    elseif ( RectContainsUnit(gg_rct_FieldLeft, target) == true and RectContainsUnit(gg_rct_FieldLeft, me) == true) then
        return true
    elseif ( RectContainsUnit(gg_rct_TokiwadaiField, target) == true and RectContainsUnit(gg_rct_TokiwadaiField, me) == true) then
        return true
    elseif ( RectContainsUnit(gg_rct_FieldUnderstair, target) == true and RectContainsUnit(gg_rct_FieldUnderstair, me) == true) then
        return true
    elseif ( RectContainsUnit(gg_rct_RectPublicBath, target) == true and RectContainsUnit(gg_rct_RectPublicBath, me) == true) then
        return true
    endif
    return false
endfunction