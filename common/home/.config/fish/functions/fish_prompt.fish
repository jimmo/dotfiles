set fish_color_cwd -o blue
set fish_color_host -o green
set fish_color_user -o green

function fish_prompt --description 'Write out the prompt'
	set -l home_escaped (echo -n $HOME | sed 's/\//\\\\\//g')
	set -l pwd (echo -n $PWD | sed "s/^$home_escaped/~/" | sed 's/ /%20/g')
	set -l prompt_symbol ''
	switch $USER
		case root toor
			set prompt_symbol '#'
		case '*'
			set prompt_symbol '$'
	end
	printf "%s%s@%s%s%s: %s%s%s%s" (set_color $fish_color_user) $USER (set_color $fish_color_host) (prompt_hostname) (set_color $fish_color_cwd) $pwd (set_color normal) (__fish_git_prompt)
	echo
	printf "%s %s " (date +%H:%M) $prompt_symbol
end
