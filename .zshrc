# https://zsh.sourceforge.io/Guide/zshguide02.html

# Enable Autocomplete and syntax highlighting
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit

	source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra,ssh-agent}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Starship!
eval "$(starship init zsh)"
