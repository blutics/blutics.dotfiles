alias ll='ls -al'
alias cd="z"
# base: 보기 좋은 일반 목록
alias ls='eza --group-directories-first --icons=auto --color=auto'
# all(숨김 포함, 사람 친화적 사이즈)
alias ll='eza -alh --header --group --icons=auto --time-style=long-iso --group-directories-first'
# tree 뷰(2~3단 적당)
alias lt='eza -T -L2 --group --icons=auto --time-style=long-iso'
alias ltt='eza -T -L3 --group --icons=auto --time-style=long-iso'
# 크기 기준 정렬(큰 것부터)
alias lS='eza -l --header -s size -r -h --icons=auto'
# 최근 변경순
alias ltoday='eza -l --header -s modified -r --icons=auto'
