
-- startup file is /usr/local/bin/xmonad.start
-- desktop file is /usr/share/xsessions/xmonad

import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers --used for fullscreen feature

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Dzen

import qualified XMonad.Prompt as P
import XMonad.Prompt.Workspace
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad

import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspace,PerWorkspace)
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Decoration
import XMonad.Layout.Simplest

import qualified XMonad.StackSet as W -- used in W.focusDown

import XMonad.Actions.CycleWS -- used for nextWS etc
import XMonad.Actions.Volume
import XMonad.Actions.TopicSpace

--  import Data.Monoid -- needed for Data.Monoid.Endo type
import System.IO
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M
import Text.Printf (printf)
import Data.List (isPrefixOf)

--  import XMonad.Config.Gnome

------------------------------ basic config ------------------------------------

myTerminal :: String
myTerminal = "gnome-terminal"

myShell :: String
myShell = "fish"

-- taken over by topics...
--  -- set up workspaces
--  myWorkspaces :: [String]
--  myWorkspaces = ["1:web","2:term", "3:mail", "4:tex"] ++ map show [5..8::Integer] ++ ["9:video"]

modm :: KeyMask
modm =
    mod4Mask

------------------------------ dzen utils --------------------------------------

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

-- avoid quotiation marks appearing when using show on Strings
displayStringLine :: String -> Int -> Int -> X ()
displayStringLine s w h = dzenConfig (timeout 1 >=> centered) s
    where centered = onCurr (center w h)
            >=> font "-*-terminus-*-r-*-*-64-*-*-*-*-*-*-*"
            >=> addArgs ["-fg", "#80c0ff"]
            >=> addArgs ["-fg", "#000040"]

-------------------------- handle volume ---------------------------------------

speakersOn :: X ()
speakersOn = spawn "amixer -D pulse sset Master on"

-------------------------- manage hook -----------------------------------------

{-
 - to find out class of a window, use xprop in terminal and click respective window
 -}
myManageHooks :: ManageHook
myManageHooks = composeAll [
    isFullscreen --> doFullFloat
    --  isFullscreen --> (doF W.focusDown <+> doFullFloat)
    , className =? "Firefox" --> doF (W.shift "web:1")
    , manageDocks
    , manageHook defaultConfig
    ]

--------------------------- log hook (mainly for xmobar) -----------------------

myLogHook :: Handle -> X ()
myLogHook xmproc = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle  = xmobarColor "green" "" . shorten 60
            }

---------------------------- layout hook ---------------------------------------

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
    delta   = 2.5/100
-- put everything together
myLayoutHook :: PerWorkspace Myvid Mydef Window
--  myLayoutHook = onWorkspace "9:video" myVideoLayout -- $ (dollar sign is needed if this is extended, uncommented due to linter...)
                --  myDefaultLayout
myLayoutHook = onWorkspace "movie:6" myVideoLayout -- $ (dollar sign is needed if this is extended, uncommented due to linter...)
                myDefaultLayout

----------------------------- key maps -----------------------------------------

additionalKeyMaps :: [((ButtonMask, KeySym), X ())]
additionalKeyMaps =
       -- enables audio keys
       [ ((0 , xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle" >>
                                  getMuteChannels ["Master"] >>=
                                  displayMuteState)
                -- (toggleMute only works when not muted, thus this workaround)
       , ((0 , xF86XK_AudioLowerVolume), speakersOn >>
                                         lowerVolume 4 >>=
                                         displayVolume)
       , ((0 , xF86XK_AudioRaiseVolume), speakersOn >>
                                         raiseVolume 4 >>=
                                         displayVolume)
       -- set volume to full
       , ((modm , xF86XK_AudioRaiseVolume), setVolume 100 >>
                                                return 100 >>=
                                                displayVolume)

       -- win - shift - f4 used for shutdown
       --  , ((modm .|. shiftMask, xK_F4), spawn "sudo shutdown -P now")
       , ((modm .|. shiftMask, xK_F4), spawn "sudo poweroff")
       , ((modm .|. shiftMask, xK_i),  spawn "sudo poweroff")

       -- decide if laptop screen may go off after timeout
       , ((modm, xK_d),                spawn "xset -dpms; xset s off" >>
                                           displayStringLine "screen timeout turned off" 850 66)
       , ((modm .|. shiftMask, xK_d),  spawn "xset +dpms; xset s on" >>
                                           displayStringLine "screen timeout turned on" 830 66)

       , ((modm, xK_f),               spawn "firefox")
       , ((modm .|. shiftMask, xK_t), spawn "thunderbird")

       -- change dmenu font and make case insensitive
       , ((modm, xK_p), spawn "dmenu_run -i -fn '10x20'")

       -- cycle through workspaces:
       , ((modm .|. shiftMask, xK_l),  shiftToNext >>
                                           nextWS)
       , ((modm .|. shiftMask, xK_h),  shiftToPrev >>
                                           prevWS)
       , ((modm .|. controlMask, xK_l ), sendMessage Expand)
       , ((modm .|. controlMask, xK_h ), sendMessage Shrink)
       , ((modm , xK_l                ), nextWS)
       , ((modm , xK_h                ), prevWS)
       , ((modm, xK_a                 ), currentTopicAction myTopicConfig)
       , ((modm, xK_g                 ), promptedGoto)
       , ((modm .|. shiftMask, xK_g   ), promptedShift)
       , ((modm, xK_w                 ), muxPrompt myXPConfig)
       , ((modm .|. shiftMask, xK_w   ), shellPrompt myXPConfig)
       , ((modm .|. controlMask, xK_w ), xmonadPrompt myXPConfig)
       --  , ((modm, xK_w                 ), spawn $ myTerminal ++ " -e 'mux logik'")
       ]

------------------------- config  for various prompts --------------------------

myXPConfig :: P.XPConfig
myXPConfig = P.greenXPConfig -- or P.amberXPConfig or P.defaultXPConfig
            {
              P.position = P.Top
            , P.height = 25
            , P.alwaysHighlight = True
            , P.font="10x20"
            }

--  spawnShell :: X ()
--  spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

spawnShellIn :: Dir -> X ()
spawnShellIn dir = spawn $ "cd " ++ dir ++ "; or " ++ myTerminal

spawnShellWith :: String -> X ()
spawnShellWith what = spawn (myTerminal ++ printf " -e '%s'" what)
 
spawnShell :: X ()
spawnShell = spawnShellWith myShell

spawnMuxShell :: String -> X ()
spawnMuxShell template = spawnShellWith $ "mux " ++ template

-- switch to given topic, perform its action
goto :: Topic -> X ()
goto = switchTopic myTopicConfig

-- prompt and goto selected topic
promptedGoto :: X ()
promptedGoto = workspacePrompt myXPConfig goto

-- prompt and shift window to selected topic
promptedShift :: X ()
promptedShift = workspacePrompt myXPConfig $ windows . W.shift

-- prompt for mux shell to open
promptedMuxShell :: P.XPConfig -> X ()
promptedMuxShell = muxPrompt

---------------- prompt used for promptedMuxShell ------------------------------

data Mux = Mux

instance P.XPrompt Mux where
        showXPrompt Mux     = "Mux Template: "
        --  completionToCommand _ = escape

muxPrompt :: P.XPConfig -> X ()
muxPrompt c = do
        let templates = ["logik", "xmonad"]
        P.mkXPrompt Mux c (getMuxCompletion templates) spawnMuxShell

getMuxCompletion :: [String] -> String -> IO [String]
getMuxCompletion ss s = return $ filter (isPrefixOf s) ss

----------------------- topics setup -------------------------------------------

-- The list of all topics/workspaces of your xmonad configuration.
-- The order is important, new topics must be inserted
-- at the end of the list if you want hot-restarting
-- to work.
myTopics :: [Topic]
myTopics =
     [ "web:1", "term:2", "mail:3", "tex:4", "dashboard:5"
     , "movie:6", "music:7", "tools:8", "xmonad:9"
     ]

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
    { topicDirs = M.fromList
                    [ ("dashboard:5", "Desktop")
                    , ("xmonad:9", ".xmonad")
                    --  , ("tools", "w/tools")
                    , ("music:7", "Music")
                    ]
    , defaultTopicAction = const $ spawnShell >*> 3
    , defaultTopic = "web"
    , topicActions = M.fromList
        [ ("mail:3",      spawn "thunderbird")
        --  [ ("xmonad",   spawnShellIn ".xmonad")
        --  , ("mail",       spawn "thunderbird")
        --  , ("dashboard",  sendMessage )
        , ("web:1",       spawn "firefox")
        , ("music:7",     spawn "nightingale")
        , ("xmonad:9",    spawnMuxShell "xmonad")
        , ("term:2",      spawn myTerminal)
        ]
    }


-- =========================== the MAIN monad ==================================

main :: IO()
main = do
    checkTopicConfig myTopics myTopicConfig
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
       { borderWidth = 4 -- window borders more visible
       --  , workspaces = myWorkspaces
       , workspaces = myTopics
       , terminal = myTerminal
       , modMask = mod4Mask -- use win key instead of alt as modifier
       , manageHook  = myManageHooks
       , layoutHook  = myLayoutHook
       , logHook     = myLogHook xmproc
       --  , focusFollowsMouse  = myFocusFollowsMouse,
       --  , borderWidth        = myBorderWidth,
       --  , normalBorderColor  = myNormalBorderColor,
       --  , focusedBorderColor = myFocusedBorderColor,
       --  , keys               = myKeys,
       --  , mouseBindings      = myMouseBindings,
       --  , startupHook        = myStartupHook
       } `additionalKeys`
       additionalKeyMaps
--  main = xmonad gnomeConfig


------------------------- appendix ---------------------------------------------

-- old stuff used for audio keys
       {-
        - [ ((0 , xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle" >>=
            -                        displayVolume)
        - , ((0 , xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 10%-" >>=
            -                               displayVolume)
        - , ((0 , xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 10%+" >>=
            -                               displayVolume)
        -}
