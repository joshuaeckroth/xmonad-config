import XMonad
import XMonad.Actions.UpdateFocus
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
    [ className =? "Gimp-2.6"    --> doFloat
    , className =? "Gimp"        --> doFloat
    , className =? "File-roller" --> doFloat
    , className =? "Xfce4-mixer" --> doFloat
    , className =? "Pidgin"      --> doFloat ]

myWorkspaces = ["r/1", "r/2", "r/3", "t/4", "t/5", "sys/6"]

myStatusBar :: String
myStatusBar = "dzen2 -fn '-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*' -bg '#000000' -fg '#888888' -h 15 -sa c -x 0 -y 0 -e '' -ta l -xs 1"
 
myConkyBar :: String
myConkyBar = "killall conky ; sleep 1 ; conky -c ~/.conkyrc | dzen2 -fn '-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*' -bg black -fg green -h 15 -sa c -x 900 -y 0 -e '' -ta l -xs 1"

myTrayer :: String
myTrayer = "killall trayer ; sleep 1 ; trayer --edge top --align right --width 10 --height 8 --heighttype pixel --padding 0 --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x000000 --SetDockType true"

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    { ppCurrent = dzenColor "black" "green" . pad
    , ppVisible = dzenColor "black" "lightgreen" . pad
    , ppHidden  = dzenColor "#dddddd" "" . pad
    , ppHiddenNoWindows = dzenColor "#888888"  "" . pad
    , ppUrgent   = dzenColor "" "red"
    , ppWsSep    = " "
    , ppSep      = " | "
    , ppTitle    = (" " ++) . dzenColor "green" "" . dzenEscape
    , ppOutput   = hPutStrLn h
      }

main = do
    workspaceBarPipe <- spawnPipe myStatusBar
    spawn myConkyBar
    spawn myTrayer
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook
        , startupHook = adjustEventInput >> (ewmhDesktopsStartup >> setWMName "LG3D")
        , handleEventHook = focusOnMouseMove
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = myLogHook workspaceBarPipe >> fadeInactiveLogHook 0xdddddddd
        , workspaces = myWorkspaces
        , modMask = mod4Mask -- rebind mod to windows key
        , terminal = "urxvt"
        , normalBorderColor  = "#dddddd"
        , focusedBorderColor = "green"
        }

