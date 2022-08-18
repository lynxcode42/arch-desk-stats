#!/usr/bin/bash
#
# Description: Installs XORG base and dwm, dmenu, st from suckless.org with patches.
# Author: lynxcode42
# Date: 2022.08.10
# Licence: open source / do as you please
#-------------------------------------------------------------------------------
# REQUIRES:
# - lynxcode42/arch-desk-stats git repo
#
# USAGE:
# $ ./01_setup_suckless.sh #!!! not as sudo or root
#-------------------------------------------------------------------------------

BINDIR="$HOME/.local/bin"
GITREPO="arch-desk-stats"
GITDIR="$HOME/$GITREPO"
GITDIRTAG="187cf50f8f0619426e98835fdeaa4f3b3dd6a3471b2efc496f50d25ffe0e19db.TAG"

echo -e "======================================================================="
echo -e "01_setup_suckless.sh && XORG base"
echo -e "======================================================================="
echo -e "[_BEGIN_] $(date +%d_%T) \n"

echo -e "\n[ 00 ]==== check if git lynxcode42/${GITREPO} exists =================="
if [ -f "$GITDIR/$GITDIRTAG" ]; then
	echo "... ok, git repo is in place.";
else
	echo "${GITREPO} repo cloning ...";
	cd $HOME;
	echo "git clone https://github.com/lynxcode42/${GITREPO}.git";
	git clone https://github.com/lynxcode42/${GITREPO}.git;
fi

echo -e "\n[ 01 ]==== replace bash profiles ===================================="
cd $HOME
mv -v .bashrc				${GITDIR}/.bashrc-BAK
mv -v .profile			${GITDIR}/.profile-BAK
mv -v .bash_profile	${GITDIR}/.bash_profile-BAK
mv -v ${GITDIR}/.bashrc				.bashrc				
mv -v ${GITDIR}/.profile			.profile			
mv -v ${GITDIR}/.bash_profile	.bash_profile	

echo -e "\n[ 02 ]==== install xorg base ========================================"
echo -e "sudo pacman -S xorg-server xorg-xinit"
sudo pacman -S xorg-server xorg-xinit

echo -e "\n[ 03 ]==== install dev libs ========================================="
echo -e "sudo pacman -S libxft libxinerama"
sudo pacman -S libxft libxinerama

echo -e "\n[ 04 ]==== build suckless tools ====================================="
echo -e "\n-- make dwm --"
echo -e "cd $GITDIR/suckless/dwm && make"
cd $GITDIR/suckless/dwm && make clean
make

echo -e "\n-- make dmenu --"
echo -e "cd ../dmenu && make"
cd ../dmenu && make clean
make

echo -e "\n-- make st --"
echo -e "cd ../st && make"
cd ../st && make clean
make

echo -e "\n-- copying binaries --"
mkdir -p ${BINDIR}
yes | cp -pfv ${GITDIR}/suckless/st/st ${BINDIR}
yes | cp -pfv ${GITDIR}/suckless/dmenu/{dmenu,dmenu_path,dmenu_run,stest} ${BINDIR}
yes | cp -pfv ${GITDIR}/suckless/dwm/dwm ${BINDIR}

echo -e "\n-- copying xinitrc and and ask for needed modifications --"
cp -v /etc/X11/xinit/xinitrc ~/.xinitrc
cat << EOF
MANUALLY replace the lines which looks like 
###
twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &
exec xterm -geometry 80x66+0+0 -name login
###

(most probably at the end of the file) in ~/.xinitrc
with the following code for DWM
###
xrandr -s 1680x1050
exec ${BINDIR}/dwm
###
EOF

echo -e "_______________________________________________________________________"
echo -e "[_END_] $(date +%d_%T)"
echo -e "_______________________________________________________________________"
echo -e "\n\nFinished all setups. Please make a clean REBOOT before usage."
echo -e "Have fun. cya.\n\n"
