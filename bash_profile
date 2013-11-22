#                 //     ///////     ////    /////  //    //        //////////  //////////    /////    //////// //////// //     ///////
#                //      //   ///   // // ///    // //    //        //     //// //     //// //     //  //          //    //     //
#  ////         //       // ///    //  //  ////     ////////        //   ////   //   ////  //       // /////       //    //     /////
# //  //  //   //        //    // ///////      ///  ////////        //////      //////     //       // //          //    //     //
#      ////   //   ///   //   // //    // //    /// //    //        //          //   //     //     //  //          //    //     //
#            //    ///   ////   //     //  //////   //    // ////// //          //    ///     /////    //       //////// ////// ///////


#/////////////////////////////
#
#   Export Vars
#
#////////////////////////
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/heroku/bin"
export EDITOR="vim"
export PS1="\W$ "
export DOTPATH="/Users/shreve/dotfiles"
export CLICOLOR=1


#/////////////////////////////
#
#   Initializers
#
#////////////////////////
eval "$(rbenv init -)"
eval "$(hub alias -s)"
eval "$(direnv hook $0)"

# Disable XOFF on <C-S>
bind -r '\C-s'
stty -ixon

#/////////////////////////////
#
#   Aliases
#
#////////////////////////
alias resource="source ~/.bash_profile; clear;"
alias tunnel="pagoda tunnel db1 -a"
alias apache="sudo apachectl" # apache (restart|status|start|stop)
alias bx="bundle exec"
alias bi="bundle install"
alias rm-ds="find . -name '.DS_Store' -depth -exec rm {} \;"
alias ls="ls -GFh"
alias games="ls /usr/share/emacs/22.1/lisp/play"
alias face="open http://www.facebook.com/"
alias restart_router="curl -F \"page=tools_gateway;logout;\" `ip r`/cgi-bin/restart.exe"
alias router="open http://`ip r`"
# TODO: Expand These Bad Jacksons
# alias copy="cat $1 | pbcopy"
# alias paste="pbpaste >>"
alias test="time rake -rminitest/pride test"
alias heorku="heroku"
alias parseint="sed -E 's/.*([0-9]+).*/\1/'"


# Files I edit often enough to neccessitate shortcuts
alias pass="vim /private/pwd"
alias hosts="sudo vim /private/etc/hosts"
alias vhosts="sudo vim /private/etc/apache2/extra/httpd-vhosts.conf"
alias profile="vim ~/.bash_profile"
alias vimrc="vim ~/.vimrc"
alias gitconfig="vim ~/.gitconfig"

# Git Aliases
alias ignore-changes="git update-index --assume-unchanged"
alias consider-changes="git update-index --assume-no-unchanged"


#/////////////////////////////
#
#   Functions
#
#////////////////////////


# cmake
# shortcut to delete old file, make it, then run it.
# probably belongs in a makefile
cmake() { rm -f "$1"; make "$1"; ./"$1"; }


recentfiles() {
	TIME=$1
	if [ "$1" == "yesterday" ]
	then
		TIME=1d
	fi
	find . -ctime -$TIME -type f ! -name '.*' ! -regex '.*/\..*/.*' ! -name '*.log'
}

#cd() {
#	JUMP=$1
#	if [ ! -d ./$1 ]; then
#		if [ -d ~/Projects/$1 ]; then
#			JUMP=~/Projects/$1
#		fi
#		
#		if [ -d ~/Sites/$1 ]; then
#			JUMP=~/Sites/$1
#		fi
#	fi
#
#	builtin cd $JUMP
#}

#_cd_() {
#	local cmd="${1##*/}"
#	local word=${COMP_WORDS[COMP_CWORD]}
#	local line=${COMP_LINE}
#	local xpat=''
#
#	COMPREPLY=(`compgen -f -- "${word}"` `cd ~/Sites/; compgen -f -- "${word}"` `cd ~/Projects/; compgen -f -- "${word}"` )
#}
#
#complete -F _cd_ cd

# touches restart.txt if it already exists to restart pow.
restart() {
	if [ -e "tmp/restart.txt" ]; then
		echo 'restarting pow...'
		touch tmp/restart.txt
	else
		echo 'not a pow project' 
	fi
}

# once a day, run brew update
brew-updater() {
    LATESTPATH="$DOTPATH/data-for/brew-updater"
    TIME=`date +%s`
    LIMIT=$[`cat $LATESTPATH` + 86400 ]
    if [ "$TIME" -ge "$LIMIT" ]; then
        echo "Time for a fresh cup..."
        brew update
        rm $LATESTPATH
        touch $LATESTPATH
        date +%s > $LATESTPATH
    fi
}

most-used() {
	history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -25
}

vc() {
	if [ -n "$1" ]
	then
		if [ -e "./$1" ]
		then
			git diff-files > /tmp/diff-files
			COUNT=`wc -l /tmp/diff-files | parseint`
			if [[ $COUNT -gt 0 ]]
			then
				BLOB=`grep $1 /tmp/diff-files| awk '{print $3}'`
				if [ -n "$BLOB" ]
				then
					TMP=`echo "$1" | sed -E "s/(.*)\.([^.]+)/\1-$BLOB.\2/"`
					git cat-file blob $BLOB > /tmp/$TMP
					vimdiff /tmp/$TMP $1
				else
					echo "File has no previous version to check. Maybe it's new or renamed."
				fi
			else
				echo "$COUNT files found by \`git diff-files\`. Are they all staged?"
				git status -s
			fi
		else
			echo "./$1 doesn't appear to exist"
		fi
	else
		echo "vim compare   usage: vc [file]"
	fi
}

yiic() {
	YIICPATH=$DOTPATH/data-for/yiic
	YIIC=`grep -i $PWD $YIICPATH`
	if [ ! -e "$YIIC" ]; then
		YIIC=$PWD/`find . -name 'yiic'`
		echo "$YIIC" | tee -a $YIIPATH
	fi
	$YIIC "$@"
}

#
#   Git-related functions
# 

# revert a single file, or all your changes.
revert-file() {
	if [ -n "$1" ]; then
		echo "Reverting file or folder: $1"
		git checkout HEAD -- $1
		git reset -- $1
	else
		echo "No file selected. Revert all changes?"
		read answer
		if [[ "${answer}" =~ "y" ]]; then
			echo "Reverting whole git directory"
			git reset
			git checkout HEAD
		else
			echo "Not reverting anything. Stay cool, bro. (!! to try again)"
		fi
	fi
}

# Delete all these damn .DS_Stores
# then run git gc, but don't tell me how it goes
garbage-collect() {
    if [[ "`pwd`" != "$HOME" ]]; then
		find . -name '.DS_Store' -exec rm {} \;
	fi
    if [ -d ./.git ]; then
        git gc --aggressive --prune=now >/dev/null
    fi
}

# stage all my changes to be commited
stage-all() {
	garbage-collect
	git add .
	git status
}

pssh() {
	echo "pssh! you think this works yet? LOL"
	#spawn ssh $1 -l $2
	#expect "password"
	#send $3;
	#interact
}

findle() {
	find . -name "$1" | grep -v "vendor/bundle"
}

cattle() {
	if [[ -n "$1" ]]; then
		SEARCH="$1"
		echo "Searching for $SEARCH"
		#sudo find . -name "$SEARCH" -exec cat {} \;
		cat `findle $SEARCH`
	else
		echo "Enter a search term"
	fi
}
