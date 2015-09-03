
-- startup file is /usr/local/bin/xmonad.start
-- desktop file is /usr/share/xsessions/xmonad

-- new mapping , useful for sending stuff to ghci below:
-- nnoremap <leader>ghci :execute '!tmux send-keys -t 2 "'@t'" Enter &'<CR>
-- vnoremap <leader>ghci "ty:execute '!tmux send-keys -t 2 "'@t'" Enter &'<CR>gv
-- (sends content of register t to pane below, also works with imports)
-- Twrite might be a better option
-- or <C-C><C-C> from tslime

import XMonad

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doFullFloat,isFullscreen)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.SetWMName

import XMonad.Util.Run (spawnPipe,runInTerm)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Dzen

import qualified XMonad.Prompt as P
import           XMonad.Prompt.Shell
import           XMonad.Prompt.XMonad
--  import           XMonad.Prompt.Workspace

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
import XMonad.Layout.IM

import qualified XMonad.StackSet as W -- used in W.focusDown

import XMonad.Actions.CycleWS -- used for nextWS etc
import XMonad.Actions.Volume
import XMonad.Actions.TopicSpace
import XMonad.Actions.GridSelect
import XMonad.Actions.Commands
import XMonad.Actions.WindowMenu

import System.IO
import Graphics.X11.ExtraTypes.XF86
import Text.Printf (printf)
import qualified Data.Map as M
import           Data.List (isPrefixOf,isInfixOf)

--  import XMonad.Config.Gnome

------------------------------ basic config ------------------------------------

myTerminal :: String
myTerminal = "gnome-terminal"

--  myShell :: String
--  myShell = "fish"

-- taken over by topics...
--  -- set up workspaces
--  myWorkspaces :: [String]
--  myWorkspaces = ["1:web","2:term", "3:mail", "4:tex"] ++ map show [5..8::Integer] ++ ["9:video"]

modm :: KeyMask
modm =
    mod4Mask

picDir :: String
picDir = "/home/skinge/Pictures/"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

----------------------------- key maps -----------------------------------------

bashRound :: String
bashRound = "awk '{printf(\"%d\\n\",$1 + 0.5)}'"

bashDzen :: String
bashDzen = "dzen2 -p 2 -x 700 -y 500 -w 520 -fn '-*-helvetica-*-r-*-*-44-*-*-*-*-*-*-*'"

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
        , ((modm , xF86XK_AudioRaiseVolume), speakersOn >>
                                                 setVolume 100 >>
                                                 return 100 >>=
                                                 displayVolume)

        , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -20 ; xbacklight | " ++ bashRound ++ " | " ++ bashDzen)
        , ((0, xF86XK_MonBrightnessUp), spawn $ "xbacklight +20 ; xbacklight | " ++ bashRound ++ " | " ++ bashDzen)

        , ((0 , xK_Print), spawn $ "scrot " ++ picDir ++ "screen_%Y-%m-%d_%H-%M-%S.png")
        , ((modm, xK_Print), spawn $ "scrot " ++ picDir ++ "screen_%Y-%m-%d_%H-%M-%S.png -u")
        --  , ((modm .|. shiftMask , xK_Print), spawn $ "scrot -s </dev/null &; sleep 4; echo ended | dzen2 -p 2;")
        , ((modm .|. shiftMask , xK_Print), runInTerm "echo foo | dzen -p 2" "")
        --  , ((modm .|. shiftMask , xK_Print), spawn $ "sh nohup scrot -s & sleep 4; echo ended | dzen2 -p 2;")
        --  , ((modm .|. shiftMask , xK_Print), spawn $ "scrot " ++ picDir ++ "screen_%Y-%m-%d_%H-%M-%S.png -s || sleep 4; echo ended | dzen2 -p 2")
        --  , ((modm, xK_b), spawn "echo foobar | dzen2 -p 2; sleep 4; echo baz | dzen2 -p 2;")
        , ((modm, xK_b), setWMName "LGD3." >> spawn "echo done | dzen2 -p 2")

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
        , ((modm, xK_adiaeresis               ) , spawn "synclient TouchpadOff=0"
                                                     >> displayStringLine "touchpad on" 500 66)
        , ((modm .|. shiftMask, xK_adiaeresis ) , spawn "synclient TouchpadOff=1"
                                                     >> displayStringLine "touchpad off" 500 66)

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

        , ((modm .|. shiftMask, xK_o), windowMenu)
        ]

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
    --  isFullscreen --> doFullFloat
    --  isFullscreen --> (doF W.focusDown <+> doFullFloat)
    --  , className =? "Firefox" --> doF (W.shift "web:1")
    className =? "Firefox" --> doF (W.shift "web:1")
    , className =? "Nightingale" --> doF (W.shift "music:6")
    , resource =? "skype" --> doF (W.shift "IM:8")
    , className =? "sun-awt-X11-XFramePeer" --> doFloat
    , className =? "Dialog" <&&> className =? "Thunderbird" --> doFloat <+> doF (W.shift "mail:3")
    , className =? "thunderbird" --> doF (W.shift "mail:3")
    , manageDocks
    , manageHook defaultConfig
    ]

-------------------------- startup hook -----------------------------------------

myStartupHook :: X()
myStartupHook = do
                    setWMName "LGD3"
                    --  spawn "skype"

--------------------------- log hook (mainly for xmobar) -----------------------

myLogHook :: Handle -> X ()
myLogHook xmproc = do
                    dynamicLogWithPP (xmobarPP { ppOutput = hPutStrLn xmproc
                                                , ppTitle  = xmobarColor "green" "" . shorten 60
                                                , ppCurrent = \a -> "<fc=orange,>[" ++ a ++ "]</fc>"
                                                , ppSep = " | "
                                                , ppLayout = xmobarColor "violet" ""
                                                })
                    fadeWindowsLogHook myFadeHook

myFadeHook :: FadeHook
myFadeHook = composeAll [ isUnfocused --> transparency 0.5
                        , isFloating --> transparency 0.7
                        , opaque
                        ]

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
type MyDefLayouts         = BoringStrutsBorder MyDefLayoutsBasic
type MyDefLayoutsBasic    = Choose TallNamed (Choose MirTallNamed (Choose TabbedNamed (Choose GridNamed SpiralNamed)))
type BoringStrutsBorder a = ModifiedLayout BoringWindows (ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder a))
type Tabbed               = ModifiedLayout (Decoration TabbedDecoration DefaultShrinker) Simplest
type SpiralNamed          = ModifiedLayout Rename SpiralWithDir
type GridNamed            = ModifiedLayout Rename Grid
type TallNamed            = ModifiedLayout Rename Tall
type TabbedNamed          = ModifiedLayout Rename Tabbed
type MirTallNamed         = ModifiedLayout Rename (Mirror Tall)
myDefaultLayout :: MyDefLayouts Window
myDefaultLayout = boringWindows $ avoidStruts $ smartBorders myDefaultLayoutsBasic

myDefaultLayoutsBasic :: MyDefLayoutsBasic Window
myDefaultLayoutsBasic = tiled ||| mirrorTiled ||| myTabbed ||| grid ||| spiralled
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

type MyDefLayoutsAlt = ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder (Choose TallNamed (Choose MirTallNamed (Choose GridNamed SpiralNamed))))
myDefaultLayoutAlt :: MyDefLayoutsAlt Window
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
type MyTexLayout = MySubLayout MyDefLayoutsAlt
myTexLayout :: MyTexLayout Window
myTexLayout = windowNavigation $ subTabbed $ boringWindows myDefaultLayoutAlt

type SkypeLayout = BoringStrutsBorder (ModifiedLayout AddRoster MyDefLayoutsBasic)
skypeLayout :: SkypeLayout Window
skypeLayout = boringWindows $ avoidStruts $ smartBorders $ withIM (1/6) skypeMainWindow myDefaultLayoutsBasic
    where
    skypeMainWindow = And (Resource "skype")
                          (Not (Or (Title "Options") 
                                   (Or (Role "ConversationsWindow")
                                       (Role "CallWindow"))))

-- put everything together
myLayoutHook :: PerWorkspace Myvid (PerWorkspace SkypeLayout (PerWorkspace MyTexLayout MyDefLayouts)) Window
myLayoutHook = onWorkspace "movie:6" myVideoLayout $
                    onWorkspace "IM:8" skypeLayout $
                    onWorkspace "tex:4" myTexLayout
                    myDefaultLayout

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
--   
--  spawnShell :: X ()
--  spawnShell = spawnShellWith myShell

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

--  -- prompt for mux shell to open
--  promptedMuxShell :: P.XPConfig -> X ()
--  promptedMuxShell = muxPrompt

---------------- prompt used for promptedMuxShell ------------------------------

data Mux = Mux

instance P.XPrompt Mux where
        showXPrompt Mux     = "Mux Template: "
        --  completionToCommand _ = escape

muxPrompt :: P.XPConfig -> X ()
muxPrompt c = do
        let templates = [ "algeo"
                        , "xmonad"
                        , "lambda"
                        , "prog"
                        , "robo"
                        , "telegram"
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
     [ "web:1", "term:2", "mail:3", "tex:4", "telegram:5"
     , "movie:6", "music:7", "IM:8", "xmonad:9"
     ]

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
    { topicDirs = M.fromList
                    [ ("telegram:5", "Desktop")
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
        --  , ("telegram",  sendMessage )
        , ("web:1",       spawn "firefox")
        , ("movie:6",     spawn "chromium-browser")
        , ("music:7",     spawn "nightingale")
        , ("xmonad:9",    spawnMuxShell "xmonad")
        , ("tex:4",       muxPrompt myXPConfig)
        , ("term:2",      spawn myTerminal)
        , ("IM:8",        spawn "skype")
        , ("telegram:5", spawnMuxShell "telegram")
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
       { borderWidth = 3 -- window borders more visible
       --  , workspaces = myWorkspaces
       , workspaces = myTopics
       , terminal = myTerminal
       , modMask = mod4Mask -- use win key instead of alt as modifier
       , manageHook  = myManageHooks
       , layoutHook  = myLayoutHook
       , logHook     = myLogHook xmproc
       , focusFollowsMouse  = myFocusFollowsMouse
       , handleEventHook = fadeWindowsEventHook
       , normalBorderColor  = "white"
       , focusedBorderColor = "orange"
       , startupHook        = myStartupHook
       --  , keys               = myKeys
       --  , mouseBindings      = myMouseBinding
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
