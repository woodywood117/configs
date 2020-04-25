set fish_greeting
fish_default_key_bindings
set -x GOPATH /home/jwood/src/go

function vim
    nvim $argv
end
funcsave vim

function ide
	tmux split-window -v -p 20
	tmux split-window -h -p 66
	tmux split-window -h -p 50
end
funcsave ide

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -x EDITOR nvim
abbr -a -g v nvim
abbr -a -g ga git add -A
abbr -a -g gc git commit
abbr -a -g gp git push
abbr -a -g gs git status
abbr -a -g tm tmux
alias gateway='ip route'
