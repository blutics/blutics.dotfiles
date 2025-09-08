
set -g @plugin 'catppuccin/tmux'

##### Catppuccin
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"

# 상태바 전체 배경/전경
set -g @catppuccin_status_foreground '#000000'
set -g @catppuccin_status_background '#282c34'

# 분리자 (오타 수정: sepa**r**ator)
set -g @catppuccin_status_left_separator  ""
set -g @catppuccin_status_right_separator "█ "
set -g @catppuccin_status_middle_separator ""
set -g @catppuccin_status_module_bg_color "#{@thm_surface_1}"
set -g @catppuccin_status_right_separator_inverse "no"
set -g @catppuccin_status_connect_separator "no"

# 윈도우 라벨 커스텀
set -g @catppuccin_window_number_position right
set -g @catppuccin_window_default_fill number 
set -g @catppuccin_window_current_text " #W \uedc6 "
set -g @catppuccin_window_default_text " #W : "

set -g @catppuccin_window_text '#{?#{==:#{window_name},},11,#W}'
set -g @catppuccin_window_number "#[bold]#I"

##### Status line
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""


set -g  status-right "#{E:@catppuccin_status_application}"
set -ag status-right "#{E:@catppuccin_status_session}"
# set -ag status-right "#{E:@catppuccin_status_uptime}"
set -ag status-right "#{E:@catppuccin_status_date_time}"
