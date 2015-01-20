
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86

main = do 
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
       { borderWidth = 4
       , manageHook  = manageDocks <+> manageHook defaultConfig
       , layoutHook  = avoidStruts $ layoutHook defaultConfig 
       , logHook     = dynamicLogWithPP xmobarPP
                            { ppOutput = hPutStrLn xmproc
                            , ppTitle  = xmobarColor "green" "" . shorten 50
                            }
       } `additionalKeys`
       [ ((mod4Mask, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
       , ((mod4Mask, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 10%-")
       , ((mod4Mask, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 10%+")
       , ((mod4Mask .|. shiftMask, xK_F4), spawn "sudo shutdown -h now")
       ]
