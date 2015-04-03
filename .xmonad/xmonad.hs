
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders -- used for smartBorders
import XMonad.Layout.PerWorkspace (onWorkspace,PerWorkspace)
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Decoration
import XMonad.Layout.Simplest
import System.IO
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.ManageHelpers --used for fullscreen feature
import qualified XMonad.StackSet as W -- used in W.focusDown
--  import Data.Monoid -- needed for Data.Monoid.Endo type
import XMonad.Actions.CycleWS -- used for nextWS etc
import XMonad.Actions.Volume
import XMonad.Util.Dzen
--  import Control.Monad (void)
--  import XMonad.Config.Gnome

-- display volume outputs using dzen
displayVolume :: Double -> X ()
displayVolume = dzenConfig (timeout 1 >=> centered) . show . (round :: Double -> Integer)
    where centered = onCurr (center 150 66)
            >=> font "-*-terminus-*-r-*-*-68-*-*-*-*-*-*-*"
            >=> addArgs ["-fg", "#80c0ff"]
            >=> addArgs ["-fg", "#000040"]

displayMuteState :: Bool -> X ()
displayMuteState = dzenConfig (timeout 1 >=> centered) . getState
    where centered = onCurr (center 300 66)
            >=> font "-*-terminus-*-r-*-*-64-*-*-*-*-*-*-*"
            >=> addArgs ["-fg", "#80c0ff"]
            >=> addArgs ["-fg", "#000040"]
          getState True = "Unmuted"
          getState False = "Muted"

-- useful for general output
{-
 - displayShowable :: (Show s) => s -> Int -> Int -> X ()
 - displayShowable s w h = (dzenConfig (timeout 1 >=> centered) . show) s
 -     where centered = onCurr (center w h)
 -             >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
 -             >=> addArgs ["-fg", "#80c0ff"]
 -             >=> addArgs ["-fg", "#000040"]
 -}

displayStringLine :: String -> Int -> Int -> X ()
displayStringLine s w h = dzenConfig (timeout 1 >=> centered) s
    where centered = onCurr (center w h)
            >=> font "-*-terminus-*-r-*-*-64-*-*-*-*-*-*-*"
            >=> addArgs ["-fg", "#80c0ff"]
            >=> addArgs ["-fg", "#000040"]

-- set up workspaces
myWorkspaces :: [String]
myWorkspaces = ["1:web","2:term", "3:mail", "4:tex"] ++ map show [5..8::Integer] ++ ["9:video"]


main :: IO()
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
{-
myStartupHook = startupHook defaultConfig
 -        { terminal           = myTerminal,
 -        , focusFollowsMouse  = myFocusFollowsMouse,
 -        , borderWidth        = myBorderWidth,
 -        , modMask            = myModMask,
 -        , workspaces         = myWorkspaces,
 -        , normalBorderColor  = myNormalBorderColor,
 -        , focusedBorderColor = myFocusedBorderColor,
 -
 -        -- key bindings
 -        , keys               = myKeys,
 -        , mouseBindings      = myMouseBindings,
 -        -- hooks, layouts
 -        , layoutHook         = smartBorders $ myLayout,
 -        , manageHook         = myManageHook,
 -        , startupHook        = myStartupHook
 -        }
 -}
       { borderWidth = 4 -- window borders more visible
       , workspaces = myWorkspaces
       , modMask = mod4Mask -- use win key instead of alt as modifier
       , manageHook  = myManageHooks
       , layoutHook  = myLayoutHook
       , logHook     = myLogHook xmproc
       } `additionalKeys`
       additionalKeyMaps
--  main = xmonad gnomeConfig

speakersOn :: X ()
speakersOn = spawn "amixer -D pulse sset Master on"

{-
 - to find out class of a window, use xprop in terminal and click respective window
 -}
myManageHooks :: ManageHook
myManageHooks = composeAll [
    isFullscreen --> doFullFloat
    --  isFullscreen --> (doF W.focusDown <+> doFullFloat)
    , className =? "Firefox" --> doF (W.shift "1:web")
    , manageDocks
    , manageHook defaultConfig
    ]

myLogHook :: Handle -> X ()
myLogHook xmproc = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle  = xmobarColor "green" "" . shorten 60
            }


{-
 - layout specification
 -}
-- default layout
type Myvid = Choose (ModifiedLayout WithBorder Full) (ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder Tall))
myVideoLayout :: Myvid Window
myVideoLayout = noBorders Full ||| (avoidStruts . smartBorders) (Tall 1 (3/300) (3/5))
-- special layout allowing fullscreen
type Tabbed = ModifiedLayout (Decoration TabbedDecoration DefaultShrinker) Simplest
type Mydef = ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder (Choose Tall (Choose (Mirror Tall) (Choose Full (Choose Grid (Choose SpiralWithDir Tabbed))))))
myDefaultLayout :: Mydef Window
myDefaultLayout = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full ||| Grid ||| spiral (6/7) ||| simpleTabbed
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 3/5
    delta   = 3/100
-- put everything together
myLayoutHook :: PerWorkspace Myvid Mydef Window
myLayoutHook = onWorkspace "9:video" myVideoLayout -- $ (dollar sign is needed if this is extended, uncommented due to linter...)
                myDefaultLayout

additionalKeyMaps :: [((ButtonMask, KeySym), X ())]
additionalKeyMaps =
       -- enables audio keys
       [ ((0 , xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle" >> getMuteChannels ["Master"] >>= displayMuteState) -- toggleMute only works when not muted, thus this workaround
       , ((0 , xF86XK_AudioLowerVolume), speakersOn >> lowerVolume 4 >>= displayVolume)
       , ((0 , xF86XK_AudioRaiseVolume), speakersOn >> raiseVolume 4 >>= displayVolume)
       , ((mod4Mask , xF86XK_AudioRaiseVolume), setVolume 100 >> return 100 >>= displayVolume) -- set volume to full
       -- win - shift - f4 used for shutdown
       --  , ((mod4Mask .|. shiftMask, xK_F4), spawn "sudo shutdown -P now")
       , ((mod4Mask .|. shiftMask, xK_F4), spawn "sudo poweroff")
       , ((mod4Mask .|. shiftMask, xK_i), spawn "sudo poweroff")
       -- decide if laptop screen may go off after timeout
       , ((mod4Mask, xK_d), spawn "xset -dpms; xset s off" >> displayStringLine "screen timeout turned off" 850 66)
       , ((mod4Mask .|. shiftMask, xK_d), spawn "xset +dpms; xset s on" >> displayStringLine "screen timeout turned on" 830 66)
       , ((mod4Mask, xK_f), spawn "firefox")
       , ((mod4Mask, xK_a), spawn "dmenu")
       -- cycle through workspaces:
       , ((mod4Mask .|. shiftMask, xK_l), nextWS)
       , ((mod4Mask .|. shiftMask, xK_h), prevWS)
       , ((mod4Mask .|. controlMask, xK_l), shiftToNext)
       , ((mod4Mask .|. controlMask, xK_h), shiftToPrev)
       ]


-- old stuff used for audio keys
       {-
        - [ ((0 , xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle" >>= displayVolume)
        - , ((0 , xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 10%-" >>= displayVolume)
        - , ((0 , xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 10%+" >>= displayVolume)
        -}
