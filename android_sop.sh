#!/bin/bash

# simple script for android devices operation
# author: chandra.c(binilinlquad), ade.imam(geekzy)

function choose_device
{
    # show your android devices and then select which
    # device that you want to operate 
    DEV=$(adb devices|tail -n +2|awk '{print $1}')
    # show your devices
    echo "Device(s) Detected :"
    local i=0
    for line in $DEV; do
        echo "$i)" "$line"
        DEVICES[$i]=$line
        i=$((i+1))
    done
    
    # ask user to choose its device
    if [ "$i" -gt 1 ]; then
        echo "Select your device:"
        read idx
    elif [ "$i" -eq 1 ]; then
       idx=0
    else
       echo "There's no device"
       exit 
    fi

    #set device
    DEVICE="${DEVICES[$idx]}"
    echo
}

function choose_command
{
    # let user choose what do they want to do
    # for now just one. You can add more command
    echo "Select command"
    echo "w) warm-restart"
    echo "p) push"
    echo "l) logcat"
    echo "c) choose-device"
    echo "q) quit"
    read COM
    case $COM in 
        w)
            restart_device;;
        p)
            push_device;;
        l)
            logcat_by_tag;;
        c)
            choose_device;;
        q)
            exit;; 
    esac
}

function restart_device
{
    # restart device
    local params='stop;sleep 5;start;'
    syntax=shell
    adb -s $DEVICE $syntax $params
}

function push_device
{
    # server as push shortcut
    echo "Input source path"
    read source_path
    echo "Input target path"
    read target_path
    adb -s $DEVICE push $source_path $target_path
}

function logcat_by_tag
{
    echo "Specify TAG"
    read tag
    adb -s $DEVICE logcat $tag:V *:S
}

choose_device
while [ true ]; do
    choose_command
done
