#!/bin/bash
#
# $1: dir for original miui app 
# $2: dir for target miui app
#

XMLMERGYTOOL=$PORT_ROOT/tools/ResValuesModify/jar/ResValuesModify
GIT_APPLY=$PORT_ROOT/tools/git.apply
MIUISRCDIR=$PORT_ROOT/miui/src

curdir=`pwd`


if [ $1 = "Settings" ];then
    $XMLMERGYTOOL $1/res/values $2/res/values
    $XMLMERGYTOOL $1/res/values-hdpi $2/res/values-hdpi
fi

if [ $1 = "Phone" ];then
	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "ThemeManager" ];then
    $XMLMERGYTOOL $1/res/values $2/res/values
    mkdir -p $2/res/drawable-hdpi/
fi

if [ $1 = "MiuiHome" ];then
    $XMLMERGYTOOL $1/res/values-xhdpi $2/res/values-xhdpi
fi

if [ $1 = "DeskClock" ];then
    mkdir -p $1
    #mkdir -p $2/res/values-hdpi/
    #cp $MIUISRCDIR/packages/apps/$1/res/values-xhdpi/*.png $2/res/values-hdpi/
fi

if [ $1 = "Music" ];then
    mkdir -p $1
    mkdir -p $2/res/values-xhdpi/
    cp $MIUISRCDIR/packages/apps/Miui$1/res/values-xhdpi/*.xml $2/res/values-xhdpi/
fi


if [ $1 = "PackageInstaller" ];then
    mkdir -p $1
    mkdir -p $2/res/drawable-hdpi/
    cp $1/res/drawable-hdpi/*.png $2/res/drawable-hdpi/
fi

if [ $1 = "MiuiCompass" ];then
    cp $1/res/drawable-hdpi/*.png $2/res/drawable-hdpi/
fi