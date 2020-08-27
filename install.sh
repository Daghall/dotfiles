# Pretty colors
COLOR_YELLOW=$(echo -e "\033[1;33m")
COLOR_GREEN=$(echo -e "\033[32m")
COLOR_RED=$(echo -e "\033[31m")
COLOR_BLUE=$(echo -e "\033[34m")
COLOR_RESET=$(echo -e "\033[0m")

function unified_diff() {
	diff -u ~/$1 ./$1;
}

# Loop over relevant files and check for diffs, ask to apply diff if found
for file in .bashrc .bash_profile .vimrc .gitconfig; do
	diff=$(unified_diff $file);

	# Is there a diff?
	if [ -n "$diff" ]; then
		clear;
		answer="NULL";

		# Print diff with pretty colors
		echo -e $COLOR_YELLOW"Diff for $file:$COLOR_RESET"
		unified_diff $file | sed -e "/^---/! s/^-/$COLOR_RED-/" -e "/^+++/! s/^\+/$COLOR_GREEN+/" -e "s/$/$COLOR_RESET/"

		# Prompt for answer
		while [[ ! $answer =~ ^[ynYN]$ ]]; do
			read -p "${COLOR_BLUE}Apply diff? [y/n] ${COLOR_RESET}" answer;
		done;

		# Check answer
		if [[ $answer =~ ^[yY] ]]; then
			cp ./$file ~/$file;
		fi
	fi
done
