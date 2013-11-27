# =================================================================================================
#
# 										1337 .bash_profile
#
# =================================================================================================
#
#	Table of Contents:
#	1.	Environment Configuration
#	2.	Sensible Defaults, and Enhancements
#	3.	File & Folder Management
#	4.	Searching
#	5.	Development
#	6.	Networking
#	7.	Processes
#	8.	Initializers
#	9.	Labs
#	10.	Bibliography




#/////////////////////////////
#
#   1.	Environment Configuration
#
#////////////////////////
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/heroku/bin"
export EDITOR="vim"
export PS1="\[\e[1;35m\]\W\$\[\e[0m\] "
export DOTPATH="/Users/shreve/dotfiles"
export CLICOLOR=1


#/////////////////////////////
#
#   2.	Sensible Defaults, and Enhancements
#
#////////////////////////
alias ~="cd ~"
alias cp="cp -iv"
alias mv="mv -iv"
alias ls="ls -FAGh"
alias ..="cd ../"
alias ...="cd ../../"
alias resource="source ~/.bash_profile; clear;"
alias tac="sed '1!G;h;\$!d'"							# cat backwards
most-used() { history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -20 ; }


#/////////////////////////////
#
#   3. File & Folder Management
#
#////////////////////////
alias pass="vim /private/pwd"											# files edited frequently enough to warrant aliases
alias hosts="sudo vim /private/etc/hosts"								#   > system hosts
alias vhosts="sudo vim /private/etc/apache2/extra/httpd-vhosts.conf"	#   > apache virtual hosts
alias profile="vim ~/.bash_profile"										#   > this file!
alias vimrc="vim ~/.vimrc"												#   > this file, but the vim version!
alias gitconfig="vim ~/.gitconfig"										#   > global git configuration
alias finder="open -a Finder ./"										# open pwd in Finder
alias rm-ds="find . -type f -name '.DS_Store' -depth -delete"			# recursively remove .DS_Store files
zipf () { zip -r "$1".zip "$1" ; }										# zip a folder
if [ ! -e "/tmp/trash.aif" ]; then
	ln -s /System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/finder/move\ to\ trash.aif /tmp/trash.aif
fi
trash () { command mv "$@" ~/.Trash ; afplay /tmp/trash.aif; }			# move a file to the trash
preview () { qlmanage -p "$*" >& /dev/null; }							# open a file in quicklook / preview


#/////////////////////////////
#
#	4. Searching
#
#////////////////////////
ff() { find . -name "$@" ; }											# find via name
ff0() { ff '*'"$@" ; }													# find where name ends with search
ff1() { ff "$@"'*' ; }													# find where name starts with search
spotlight() { mdfind "kMDItemDisplayName == '$@'wc" ; }					# find via spotlight
recentfiles() {															# find via ctime
	TIME=$1
	if [ "$1" == "yesterday" ]
	then
		TIME=1d
	fi
	find . -ctime -$TIME -type f ! -name '.*' ! -regex '.*/\..*/.*' ! -name '*.log'
}

#/////////////////////////////
#
#	5.	Development
#
#////////////////////////
alias apache="sudo apachectl"											# apache (restart|status|start|stop)
alias bx="bundle exec"													# bundle execute
alias bi="bundle install"												#        install
alias bu="bundle update"												#        update
alias vi="vim"															# goddamn vi
alias heorku="heroku"													# goddamn heroku, keyboard acrobatics
alias test="time rake -rminitest/pride test"							# default to rainbow tests
cmake() { rm -f "$1"; make "$1"; ./"$1"; }								# shortcut from learning c
pr() { if [ -e "tmp/restart.txt" ]; then touch tmp/restart.txt; fi }	# pow restart

# git
alias ignore-changes="git update-index --assume-unchanged"				# assume file will never change
alias consider-changes="git update-index --assume-no-unchanged"			# assume file can change
revert-file() {															# revert a single file, or all your changes.
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
garbage-collect() {														# delete files, and let git do GC magic
    if [[ "`pwd`" != "$HOME" ]]; then rm-ds; fi
    if [ -d ./.git ]; then git gc --aggressive --prune=now > /dev/null 2>&1; fi
}

stage-all() { garbage-collect; git add .; git status ;}					# stage all my changes to be commited


#/////////////////////////////
#
#	6.	Networking
#
#////////////////////////
alias router="open http://`ip r`"										# open router in the browser
restart_router() {														# restart my home router (belkin whatevs)
	curl -F "page=tools_gateway;logout;" `ip r`/cgi-bin/restart.exe
}


#/////////////////////////////
#
#	7.	Processes
#
#////////////////////////
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'		# find top cpu users
findPid() { lsof -t -c "$@" ; }											# find pid via name
myps() { ps $@ -u $USER -o pid,%cpu,%mem,time,bsdtime,command ; }		# list my processes


#/////////////////////////////
#
#   8.	Initializers
#
#////////////////////////
eval "$(rbenv init -)"
eval "$(hub alias -s)"
eval "$(direnv hook $0)"

# Disable XOFF on <C-S>
bind -r '\C-s'
stty -ixon


#         .---.
#        _\___/_
#         )\_/(
#        /     \
#       /       \
#      /         \
#     /~~~~~~~~~~~\
#    /   9. Labs   \
#   (               )
#    `-------------'

alias games="ls /usr/share/emacs/22.1/lisp/play"
alias parseint="sed -E 's/.*([0-9]+).*/\1/'"

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


#/////////////////////////////
#
#	10.	Bibliography
#
#////////////////////////
#
#	some of the above functionality was bespoke, but plenty of
#	it was ⌘C ⌘V'd in from, or inspired by other people who've
#	posted their dotfiles online. Here are some that I
#	remembered to write down.
#
#	Ben Orenstein (@r00k)
#	https://github.com/r00k/dotfiles
#
#	Nathanel Landau (@natelandau)
#	http://natelandau.com/my-mac-osx-bash_profile/
#
#////////////////////////////////////////////////////////////////


# ================================================================================================
#
#											fin
#
# ================================================================================================
