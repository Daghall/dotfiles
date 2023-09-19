#!/usr/bin/env sh

reset='\x1b[0m'
red='\x1b[31m'
green='\x1b[32m'
yellow='\x1b[33m'
blue='\x1b[34m'
red_bg='\x1b[41m'
green_bg='\x1b[42m'
blue_bg='\x1b[44m'
default='\x1b[39m'
faint='\x1b[2m'

echo "Sequence: ${yellow}{ESC}${reset}[${yellow}{n}${reset}${faint}[;${yellow}{n}${default}]${reset}m\n"
echo "Example:\n  \\\x1b[31;1;9m => \x1b[31;1;9mRed, strong, strike\n${reset}"
echo ' 0 reset'
echo " \x1b[1m1 strong\x1b[21m\t\x1b[9m(21 unset)$reset"
echo " \x1b[2m2 faint\x1b[22m \t(22 unset)$reset"
echo " \x1b[3m3 cursive\x1b[23m\t(23 unset)$reset"
echo " \x1b[4m4 underline\x1b[24m\t(24 unset)$reset"
echo " \x1b[7m7 reverse\x1b[27m\t(27 unset)$reset"
echo " \x1b[9m9 strike\x1b[29m\t(29 unset)$reset"
echo "\x1b[30m30 black$reset"
echo "\x1b[31m31 red$reset"
echo "\x1b[32m32 green$reset"
echo "\x1b[33m33 yellow$reset"
echo "\x1b[34m34 blue$reset"
echo "\x1b[35m35 magenta$reset"
echo "\x1b[36m36 cyan$reset"
echo "\x1b[37m37 white$reset"
echo "\x1b[38m38;2;${red}{r}${reset};${green}{g}${reset};${blue}{b}${reset}m;$reset"
echo "\x1b[39m39 default$reset"
echo "\x1b[40m40 black background$reset"
echo "\x1b[41m41 red background$reset"
echo "\x1b[42m42 green background$reset"
echo "\x1b[43m43 yellow background$reset"
echo "\x1b[44m44 blue background$reset"
echo "\x1b[45m45 magenta background$reset"
echo "\x1b[46m46 cyan background$reset"
echo "\x1b[47m47 white background$reset"
echo "\x1b[38m48;2;${red_bg}{r}${reset};${green_bg}{g}${reset};${blue_bg}{b}${reset}m;$reset"
echo "\x1b[49m49 default background$reset"
