#! /bin/bash

function play ()
{
	#if ps -ef | grep -q '[e]xaile';
	#then
		exaile -t;
	#else
	#	exaile;
	#fi
}

function prev ()
{
	exaile -p
}

function next ()
{
	exaile -n
}

function info ()
{
	exaile --gui-query
}

$@
