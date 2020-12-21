-- Script to initialise variables necessary for the module to run

moduleName="utility"
players={}
notifyOrder={}
map={}
currentTime=0
SPAWNEDOBJS = {}
_S = {}

ranks={
    ['Shamousey#0015']=5,
}

RANKS={
    STAFF=5,
    ROOM_OWNER=4,
    ROOM_ADMIN=3,
    ANY=1
}

modes={
    tribe="mapMode_tribe",
    tribehouse="mapMode_tribe",
    bootcamp="mapMode_bootcamp",
    shaman="mapMode_shaman",
    sham="mapMode_shaman",
    dual="mapMode_dual_shaman",
    all="mapMode_all_shaman",
    vampire="mapMode_vampire",
    vamp="mapMode_vampire",
    racing="mapMode_racing",
    survivor="mapMode_survivor",
}

translations = {}
maps = {}

toRespawn={}

mapInfo={
    lastLoad=os.time()-5000,
    queue={},
}
map={}

KEYS={
    LEFT=0,
    UP=1,
    RIGHT=2,
    DOWN=3,
    BACKSPACE=8,
    SHIFT=16,
    CTRL=17,
    ALT=18,
    CAPS=20,
    ESCAPE=27,
    SPACE=32,
    PAGEUP=33,
    PAGEDOWN=34,
    END=35,
    HOME=36,
    LEFT_ARROW=37,
    UP_ARROW=38,
    RIGHT_ARROW=39,
    DOWN_ARROW=40,
    DELETE=46,
    [0]=48,
    [1]=49,
    [2]=50,
    [3]=51,
    [4]=52,
    [5]=53,
    [6]=54,
    [7]=55,
    [8]=56,
    [9]=57,
    A=65,
    B=66,
    C=67,
    D=68,
    E=69,
    F=70,
    G=71,
    H=72,
    I=73,
    K=75,
    J=74,
    L=76,
    M=77,
    N=78,
    O=79,
    P=80,
    Q=81,
    R=82,
    S=83,
    T=84,
    U=85,
    V=86,
    W=87,
    X=88,
    Y=89,
    Z=90,
    ["WINDOWS"]=91,
    ["CONTEXT"]=93,
    ["NUMPAD 0"]=96,
    ["NUMPAD 1"]=97,
    ["NUMPAD 2"]=98,
    ["NUMPAD 3"]=99,
    ["NUMPAD 4"]=100,
    ["NUMPAD 5"]=101,
    ["NUMPAD 6"]=102,
    ["NUMPAD 7"]=103,
    ["NUMPAD 8"]=104,
    ["NUMPAD 9"]=105,
    ["F1"]=112,
    ["F2"]=113,
    ["F3"]=114,
    ["F4"]=115,
    ["F5"]=116,
    ["F6"]=117,
    ["F7"]=118,
    ["F8"]=119,
    ["F9"]=120,
    ["F10"]=121,
    ["F11"]=122,
    ["F12"]=123,
    ["NUMLOCK"]=144,
    [";"]=186,
    ["="]=187,
    [","]=188,
    ["-"]=189,
    ["."]=190,
    ["/"]=191,
    ["'"]=192,
    ["["]=219,
    ["\\"]=220,
    ["]"]=221,
    ["#"]=222,
    ["`"]=223,
}

-- Particle IDs for fireworks
REDWHITEBLUE = {13,0,-1}

tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAfkDeath(true)

_,_,suffix=string.find((tfm.get.room.name:sub(1,2)=="e2" and tfm.get.room.name:sub(3)) or tfm.get.room.name,"%d+(.+)$")
local roomSuffix = string.match(tfm.get.room.name, "%d+(.-)$")