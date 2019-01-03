#!/bin/sh
# version with clean input

echo "DEBUG:" > $HOME/debug_createsymlink.txt

SH_DEBUG_ON="ON"
SH_DEBUG_OFF="OFF"

SH_DEBUG=$SH_DEBUG_ON
#SH_DEBUG=$SH_DEBUG_OFF

function d_echo {
	if [ $SH_DEBUG == $SH_DEBUG_ON ]
	then
		echo "DEBUG::"$*"::" 
		echo "DEBUG::"$*"::" >> $HOME/debug_createsymlink.txt
	fi

}  


fileSuffix=".link"

for name in "$@"
do
	d_echo "Name:" $name #debug name

	# HEREDOC
	export NAME="$name"
	
	a_dirname=$(ruby <<-EORUBY
	n=ENV["NAME"]
	puts File.dirname(n)
	EORUBY
	)

	a_filename=$(ruby <<-EORUBY
	n=ENV["NAME"]
	puts File.basename(n)
	EORUBY
	)	
	
	d_echo "a_dirname:"$a_dirname
	d_echo "a_filename:"$a_filename
	
	if [ -d $name ]
		then
			a_dirname="$name"				
		else
			#a_filename=basename "$name"
			#a_dirname=dirname "$name"
			d_echo "filename:"$a_filename
			d_echo "dir:"$a_dirname
		fi
			
	newname=$name$fileSuffix
	
	# if writing is allowed
	if [ -w "$a_dirname" ]
		then 
			if [ ! -e "$newname" ]
    		then
    			d_echo "writing is allowed"
    			ln -s "$name" "$newname"
    		fi
	else
		# if writing is NOT allowed ... write to: $HOME/Desktop	
		d_echo "writing in old path is NOT allowed:"$a_dirname
		newname=$HOME/Desktop/$a_filename$fileSuffix
		if [ ! -e "$newname" ]
    	then 	
    		d_echo "crate link in Desktop"	
    		ln -s "$name" "$newname"
    	fi		
	fi 
 done
