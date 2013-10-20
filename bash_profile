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


#/////////////////////////////
#
#   Initializers
#
#////////////////////////
eval "$(rbenv init -)"
eval "$(hub alias -s)"
eval "$(direnv hook $0)"


#/////////////////////////////
#
#   Aliases
#
#////////////////////////
alias resource="source ~/.bash_profile; clear;"
alias tunnel="pagoda tunnel db1 -a"
alias apache="sudo apachectl" # apache (restart|status|start|stop)
alias bx="bundle exec"
alias rm-ds="find . -name '.DS_Store' -depth -exec rm {} \;"

# Files I edit often enough to neccessitate shortcuts
alias pass="vim /private/pwd"
alias hosts="sudo vim /private/etc/hosts"
alias vhosts="sudo vim /private/etc/apache2/extra/httpd-vhosts.conf"
alias profile="vim ~/.bash_profile"
alias vimrc="vim ~/.vimrc"

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

# addToPow
# 1. Symlinks to pow directory
# 2. Tries to connect pow log to logs directory
# 3. bundle install just because
# 4. Opens it
# 5. Sets up the logging
addToPow() {
	if [[  -n "$1" ]]; then
		echo "adding ~/sites/$1/ to pow"
		ln -s ~/sites/$1/ ~/.pow/$1
		cd ~/sites/$1/
		echo "symlinking pow logs"
		LOGPATH="~/Library/Logs/Pow/apps/$1.log"
		if [[ ! -e $LOGPATH ]]; then
				touch $LOGPATH
		fi
		ln -s $LOGPATH log/pow.log
		echo "running bundle install"
		bundle install
		echo "opening."
		open "http://$1.dev/"
		echo "Running Logs"
		tail -f log/pow.log
	else
		echo "\`addToPow site\` where site is in ~/Sites/"
	fi
}

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
    #find . -name '*.swp' -exec rm {} \;
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
