#i zsh-completions(補完機能)の設定
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
autoload -U compinit
compinit -u

##################################################
### aliases 
# Git系
alias g='git'
alias gs='git status'
alias gb='git branch'
alias gc= 'git clone'
alias gco='git checkout'
alias gct='git commit'
alias gg='git grep'
alias ga='git add'
alias gd='git diff'
alias gl='git log'
alias gcma='git checkout master'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gmod='git merge origin/develop'
alias gmud='git merge upstream/develop'
alias gmom='git merge origin/master'
alias gcm='git commit -m'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gst='git stash'
alias gsl='git stash list'
alias gsu='git stash -u'
alias gsp='git stash pop'

#vim教
alias v='vim'
alias vi='vim'
#ls系
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -lh'
#処理確認
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
#よく使うコマンド(ゆくゆくはAtoZまで埋めたい！)
alias c='clear'
alias h='history'
#zsh(zshいじる趣味が無いなら要らない)
alias zsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'

##################################################
### オプション

# 同時に起動しているzshの間でhistoryを共有する
setopt share_history

# 同じコマンドをhistoryに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンドをhistoryに残さない
setopt hist_ignore_space

# historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# cd無しでもディレクトリ移動
setopt auto_cd

# コマンドのスペルミスを指摘
setopt correct

export CLICOLOR=1

autoload -Uz compinit && compinit  # Gitの補完を有効化

autoload -U colors; colors
# git ブランチ名を色付きで表示させるメソッド
function git-branch {
  local branch_name st branch_status
  
  branch='\ue0a0'
  color='%{\e[38;5;' #  文字色を設定
  green='010m%}'
  red='009m%}'
  yellow='226m%}'
  blue='236m%}'
  pink='207m%}'
  reset='%{\e[0m%}'   # reset
  
  if [ ! -e  ".git" ]; then
    # git 管理されていないディレクトリは何も返さない
    echo "${color}${pink}HEAD"
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全て commit されてクリーンな状態
    branch_status="${color}${green}${branch}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # git 管理されていないファイルがある状態
    branch_status="${color}${red}${branch}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git add されていないファイルがある状態
    branch_status="${color}${red}${branch}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commit されていないファイルがある状態
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "${color}${red}${branch}!(no branch)${reset}"
    return
  else
    # 上記以外の状態の場合
    branch_status="${color}${blue}${branch}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}$branch_name"
}

function left-prompt {

  text_color='%{\e[38;5;'
  back_color='%{\e[30;48;5;'
  branch_t='236m%}'
  branch_b='021m%}'
  name_t='179m%}'
  name_b='000m%}'
  path_t='236m%}'     # path text clolr
  path_b='214m%}'
  arrow_t='087m%}'   # arrow color
  reset='%{\e[0m%}'   # reset
  sharp='\uE0B0'      # triangle

  default_user_name='tm'
  user_name=$USER
  if [ $user_name = 'tsuchiya-mitsuki' ]; then
    user_name=$default_user_name
  fi

  user="${back_color}${name_b}${text_color}${name_t}"
  dir="${back_color}${path_b}${text_color}${path_t}"
  branch="${back_color}${branch_b}"
  echo "${user}${user_name}%#@%m  ${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~ ${back_color}${branch_b}${text_color}${path_b}${sharp}  ${branch}`git-branch`${reset}${text_color}${branch_b}${sharp}${reset}\n${text_color}${arrow_t}→ ${reset}\n"
}

PROMPT='`left-prompt`' 

function right-prompt {
  text_color='%{\e[38;5;'
  time_t='082m%}'
  reset='%{\e[0m%}'   # reset
  echo "${text_color}${time_t}[%D %*]${reset}"
}

RPROMPT='`right-prompt`'
setopt prompt_subst

# コマンドの実行ごとに改行
function precmd() {
    # Print a newline before the prompt, unless it's the
    # first pnrompt in the process.
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}

echo 'read zshrc successfully'
