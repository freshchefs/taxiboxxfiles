#!/bin/sh
#
# Process input to a CGI script. Written and Copyright 1995 Frank Pilhofer
# You may freely use and distribute this code free of charge provided that
# this copyright notice remains.            fp@informatik.uni-frankfurt.de
#########################################################################
################## Edited Prajith. (GET Bug fixed)#######################
#########################################################################
# All variables in here are prefixed by _F_, so you shouldn't have
# any conflicts with your own var names
#
# get query string. if $REQUEST_METHOD is "POST", then it must be read
# from stdin, else it's in $QUERY_STRING
#
#
if [ "$REQUEST_METHOD" = "POST" ] ; then
	_F_QUERY_STRING=`dd count=$CONTENT_LENGTH bs=1 2> /dev/null`"&"
	if [ "$QUERY_STRING" != "" ] ; then
		_F_QUERY_STRING="$_F_QUERY_STRING""$QUERY_STRING""&"
	fi
else
	_F_QUERY_STRING="$QUERY_STRING""&"
fi
#
# if there are arguments, use them as well.
#
for _F_PAR in $* ; do
	_F_QUERY_STRING="$_F_QUERY_STRING""$_F_PAR""&"
done
#
# if $PATH_INFO is not empty and contains definitions '=', append it as well.
# but replace slashes by ampersands
#
if echo $PATH_INFO | grep = > /dev/null ; then
	_F_PATH_INFO="$PATH_INFO""//"

	while [ "$_F_PATH_INFO" != "" -a "$_F_PATH_INFO" != "/" ] ; do
		_F_QUERY_STRING="$_F_QUERY_STRING""`echo $_F_PATH_INFO | cut -d / -f 1`""&"
		_F_PATH_INFO=`echo $_F_PATH_INFO | cut -s -d / -f 2-`
	done
fi
#
# append another '&' to fool some braindead cut implementations. Test yours:
# echo 'i am braindead!' | cut -d '!' -f 2
#
_F_QUERY_STRING="$_F_QUERY_STRING""&"
#
#
while [ "$_F_QUERY_STRING" != "" -a "$_F_QUERY_STRING" != "&" ] ; do
	_F_VARDEF=`echo $_F_QUERY_STRING | cut -d \& -f 1`
#	_F_QUERY_STRING=`echo $_F_QUERY_STRING | cut -d \& -f 2-`
	_F_VAR=`echo $_F_VARDEF | cut -d = -f 1`
	_F_VAL=`echo "$_F_VARDEF""=" | cut -d = -f 2`

#
# Workaround for more braindead cut implementations that strip delimiters
# at the end of the line (i.e. HP-UX 10)
#

	if echo $_F_QUERY_STRING | grep -c \& > /dev/null ; then
		_F_QUERY_STRING=`echo $_F_QUERY_STRING | cut -d \& -f 2-`
	else
		_F_QUERY_STRING=""
	fi

	if [ "$_F_VAR" = "" ] ; then
		continue
	fi

#
# replace '+' by spaces
#

	_F_VAL="$_F_VAL""++"
	_F_TMP=

	while [ "$_F_VAL" != "" -a "$_F_VAL" != "+" -a "$_F_VAL" != "++" ] ; do
		_F_TMP="$_F_TMP""`echo $_F_VAL | cut -d + -f 1`"
		_F_VAL=`echo $_F_VAL | cut -s -d + -f 2-`

		if [ "$_F_VAL" != "" -a "$_F_VAL" != "+" ] ; then
			_F_TMP="$_F_TMP"" "
		fi
	done

#
# replace '%XX' by ascii character. the hex sequence MUST BE uppercase
#

	_F_TMP="$_F_TMP""%%"
	_F_VAL=

	while [ "$_F_TMP" != "" -a "$_F_TMP" != "%" ] ; do
		_F_VAL="$_F_VAL""`echo $_F_TMP | cut -d % -f 1`"
		_F_TMP=`echo $_F_TMP | cut -s -d % -f 2-`

		if [ "$_F_TMP" != "" -a "$_F_TMP" != "%" ] ; then
			_F_HEX=`echo $_F_TMP | cut -c 1-2 | tr "abcdef" "ABCDEF"`
			_F_TMP=`echo $_F_TMP | cut -c 3-`
#
# can't handle newlines anyway. replace by space
#
#			if [ "$_F_HEX" = "0A" ] ; then
#				_F_HEX="20"
#			fi

			_F_VAL="$_F_VAL""`echo -e '\x'$_F_HEX`"
		fi
	done

#
# replace forward quotes to backward quotes, since we have trouble handling
# the former ones.
#

	_F_VAL=`echo $_F_VAL | tr "'" '\`'`

#
# if debug, send variables to stderr
#

#	/bin/echo "FORM_$_F_VAR"=\'$_F_VAL\'
	echo "FORM_$_F_VAR"="'"$_F_VAL"'"
done
#
#
# done.
#
exit 0

