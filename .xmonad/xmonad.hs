
-- startup file is /usr/local/bin/xmonad.start
-- desktop file is /usr/share/xsessions/xmonad

import XMonad

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doFullFloat,isFullscreen)
import XMonad.Hooks.DynamicLog

import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Dzen

import qualified XMonad.Prompt as P
--  import           XMonad.Prompt.Workspace
import           XMonad.Prompt.Shell
import           XMonad.Prompt.XMonad

import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspace,PerWorkspace)
import XMonad.Layout.Decoration
import XMonad.Layout.Named
import XMonad.Layout.Renamed (Rename)
import XMonad.Layout.SubLayouts
import XMonad.Layout.BoringWindows as B (focusUp,focusDown,BoringWindows,boringWindows)
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest

import qualified XMonad.StackSet as W -- used in W.focusDown

import XMonad.Actions.CycleWS -- used for nextWS etc
import XMonad.Actions.Volume
import XMonad.Actions.TopicSpace
import XMonad.Actions.GridSelect
import XMonad.Actions.Commands

import System.IO
import Graphics.X11.ExtraTypes.XF86
import Text.Printf (printf)
import qualified Data.Map as M
import           Data.List (isPrefixOf,isInfixOf)

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

-- default layout
type Myvid = ModifiedLayout BoringWindows (Choose FullNamed TiledNamed)
type FullNamed = ModifiedLayout Rename (ModifiedLayout WithBorder Full)
type TiledNamed = ModifiedLayout Rename (ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder Tall))
myVideoLayout :: Myvid Window
myVideoLayout = boringWindows $ full ||| tall
    where
      full = named "full" $ noBorders Full
      tall = named "tiled" $ (avoidStruts . smartBorders) (Tall 1 (3/300) (3/5))

-- special layout allowing fullscreen
type Tabbed       = ModifiedLayout (Decoration TabbedDecoration DefaultShrinker) Simplest
type Mydef        = ModifiedLayout BoringWindows (ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder (Choose TallNamed (Choose MirTallNamed (Choose TabbedNamed (Choose GridNamed SpiralNamed))))))
type SpiralNamed  = ModifiedLayout Rename SpiralWithDir
type GridNamed    = ModifiedLayout Rename Grid
type TallNamed    = ModifiedLayout Rename Tall
type TabbedNamed  = ModifiedLayout Rename Tabbed
type MirTallNamed = ModifiedLayout Rename (Mirror Tall)
myDefaultLayout :: Mydef Window
myDefaultLayout = boringWindows $ avoidStruts $ smartBorders $ tiled ||| mirrorTiled ||| myTabbed ||| grid ||| spiralled
  where
    tiled       = named "vert" tall
    tall        = Tall nmaster delta ratio
    mirrorTiled = named "horiz" $ Mirror tall
    myTabbed    = named "tabbed" simpleTabbed
    grid        = named "grid" Grid
    spiralled   = named "spiral" $ spiral (6/7)
    nmaster     = 1
    ratio       = 3/5
    delta       = 2.5/100

type MydefAlt        = ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder (Choose TallNamed (Choose MirTallNamed (Choose GridNamed SpiralNamed))))
myDefaultLayoutAlt :: MydefAlt Window
myDefaultLayoutAlt = avoidStruts $ smartBorders $ alttiled ||| altmirrorTiled ||| altgrid ||| altspiralled
  where
    alttiled       = named "vert" alttall
    alttall        = Tall altnmaster altdelta altratio
    altmirrorTiled = named "horiz" $ Mirror alttall
    altgrid        = named "grid" Grid
    altspiralled   = named "spiral" $ spiral (6/7)
    altnmaster     = 1
    altratio       = 3/5
    altdelta       = 2.5/100
type MySubLayout a = ModifiedLayout WindowNavigation (ModifiedLayout (Decoration TabbedDecoration DefaultShrinker) (ModifiedLayout (Sublayout Simplest) (ModifiedLayout BoringWindows a)))
type MyTexLayout = MySubLayout MydefAlt
myTexLayout :: MyTexLayout Window
myTexLayout = windowNavigation $ subTabbed $ boringWindows myDefaultLayoutAlt

-- put everything together
myLayoutHook :: PerWorkspace Myvid (PerWorkspace MyTexLayout Mydef) Window
myLayoutHook = onWorkspace "movie:6" myVideoLayout $
                    onWorkspace "tex:4" myTexLayout
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
        --  , ((modm .|. shiftMask, xK_F4), spawn "sudo poweroff")
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
        , ((modm, xK_i                 ), goToSelected defaultGSConfig)
        , ((modm, xK_o                 ), gridSelectTopics)
        -- odiaeresis is ö (ü and ä similar)
        , ((modm, xK_odiaeresis               ) , spawn "synclient HorizTwoFingerScroll=0"
                                                     >> displayStringLine "horizontal scrolling off" 800 66)
        , ((modm .|. shiftMask, xK_odiaeresis ) , spawn "synclient HorizTwoFingerScroll=1"
                                                     >> displayStringLine "horizontal scrolling on" 800 66)

         -------- used in subtabbed layout --------
         -- don't yet know what these do:
        , ((modm .|. controlMask .|. shiftMask , xK_h), sendMessage $ pullGroup L)
        , ((modm .|. controlMask .|. shiftMask , xK_l), sendMessage $ pullGroup R)
        , ((modm .|. controlMask .|. shiftMask , xK_k), sendMessage $ pullGroup U)
        , ((modm .|. controlMask .|. shiftMask , xK_j), sendMessage $ pullGroup D)
        -- merging and unmerging
        , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
        , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
        -- switch windows inside group
        , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
        , ((modm .|. controlMask, xK_comma ), onGroup W.focusDown')
        -- switch windows outside group
        , ((modm, xK_k), B.focusUp)
        , ((modm, xK_j), B.focusDown)

        , ((modm, xK_c), commands >>= runCommand)
        ]

------------------------- commands to be run with modm-c -----------------------

commands :: X [(String, X ())]
commands = do defCmds <- defaultCommands
              let cmds = [ ("gPushD", sendMessage (pushGroup D))
                         , ("gPushU", sendMessage (pushGroup U))
                         , ("gPushL", sendMessage (pushGroup L))
                         , ("gPushR", sendMessage (pushGroup R))
                         , ("wPushD", sendMessage (pushWindow D))
                         , ("wPushU", sendMessage (pushWindow U))
                         , ("wPushL", sendMessage (pushWindow L))
                         , ("wPushR", sendMessage (pushWindow R))
                         , ("wPullD", sendMessage (pullWindow D))
                         , ("wPullU", sendMessage (pullWindow U))
                         , ("wPullL", sendMessage (pullWindow L))
                         , ("wPullR", sendMessage (pullWindow R))
                         ]
              return $ cmds ++ defCmds


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

--  spawnShellIn :: Dir -> X ()
--  spawnShellIn dir = spawn $ "cd " ++ dir ++ "; or " ++ myTerminal

spawnShellWith :: String -> X ()
spawnShellWith what = spawn (myTerminal ++ printf " -e '%s'" what)
 
spawnShell :: X ()
spawnShell = spawnShellWith myShell

spawnMuxShell :: String -> X ()
spawnMuxShell template = spawnShellWith $ "mux " ++ template

-- switch to given topic, perform its action
goto :: Topic -> X ()
goto = switchTopic myTopicConfig

data TopicPrompt = TopicGotoPrompt | TopicMovePrompt

instance P.XPrompt TopicPrompt where
    showXPrompt TopicGotoPrompt = "Goto Topic: "
    showXPrompt TopicMovePrompt = "Move to Topic: "

topicComplFunct :: String -> IO [String]
topicComplFunct s = do
    let ss  = myTopics
    let res = filter (s `isInfixOf`) ss
    return res

topicPrompt :: TopicPrompt -> P.XPConfig -> (String -> X()) -> X ()
topicPrompt tprompt xpConfig = P.mkXPrompt tprompt xpConfig topicComplFunct

promptedGoto :: X ()
promptedGoto = topicPrompt TopicGotoPrompt myXPConfig goto

--  -- prompt and goto selected topic
--  promptedGoto' :: X ()
--  promptedGoto' = workspacePrompt myXPConfig goto

-- prompt and shift window to selected topic
promptedShift :: X ()
promptedShift = topicPrompt TopicMovePrompt myXPConfig $ windows . W.shift

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
        let templates = [ "algeo"
                        , "logik"
                        , "xmonad"
                        , "lambda"
                        ]
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
    --  , defaultTopicAction = const $ spawnShell >*> 3 -- spawn three shells
    , defaultTopicAction = const $ return ()
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

----------------------- grid select topics -------------------------------------

gridSelectTopics :: X ()
gridSelectTopics = do
    topic <- gridselect defaultGSConfig (zip myTopics myTopics)
    case topic of
         Just t  -> switchTopic myTopicConfig t
         Nothing -> return ()

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


-- ========================== possible dzen status bar =========================

--  myDzenBar :: String
--  myDzenBar = "dzen2 -x '0' -y '0' -h '24' -w '1440' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
--  --  myStatusBar = "conky -c /home/my_user/.xmonad/.conky_dzen | dzen2 -x '2080' -w '1040' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"
--  in main:
    --  dzenLeftBar <- spawnPipe myDzenBar
    --  --  dzenRightBar <- spawnPipe myStatusBar
       --  , logHook     = myLogHook dzenLeftBar
{-
 - myLogHook h = dynamicLogWithPP $ defaultPP
 - myLogHook h = dynamicLogWithPP $ dzenPP
 -             { ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
 -             , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
 -             , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
 -             , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
 -             , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
 -             , ppWsSep             =   " "
 -             , ppSep               =   "  |  "
 -             , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
 -                 (\xx -> case xx of
 -                             --  "ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
 -                             --  "Mirror ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
 -                             --  "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
 -                             "Simple Float"              ->      "~"
 -                             _                           ->      xx
 -                             )
 -             , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
 -             , ppOutput            =   hPutStrLn h
 -             }
 -}

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
