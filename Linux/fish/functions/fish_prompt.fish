# name: boby based in bobthefish but remasterized for use with vcprompt and virtualenv 
# and some colors changed
#
# bobthefish is a Powerline-style, Git-aware fish theme optimized for awesome.
#
# You will probably need a Powerline-patched font for this to work:
#
#     https://powerline.readthedocs.org/en/latest/fontpatching.html
#
# I recommend picking one of these:
#
#     https://github.com/Lokaltog/powerline-fonts
#
# You can override some default options in your config.fish:
#
#     set -g theme_display_user yes
#     set -g default_user your_normal_user

set -g current_bg NONE

# Powerline glyphs
set branch_glyph            \uE0A0
set ln_glyph                \uE0A1
set padlock_glyph           \uE0A2
set right_black_arrow_glyph \uE0B0
set right_arrow_glyph       \uE0B1
set left_black_arrow_glyph  \uE0B2
set left_arrow_glyph        \uE0B3

# Additional glyphs
set detached_glyph          \u27A6
set nonzero_exit_glyph      '! '
set superuser_glyph         '$ '
set bg_job_glyph            '% '

#set virtual_env_glyph           \u13e4   # CHEROKEE LETTER TSE

# Colors
set lt_green   addc10
set med_green  189303
set dk_green   0c4801

set lt_red     C99
set med_red    ce000f
set dk_red     600

#
set malibu 0087AF
set light_sky_blue 87d7ff


set lt_orange  f6b117
set dk_orange  3a2a03

set dk_grey    333
set med_grey   999
set lt_grey    ccc

set white      ffffff
set black      000000

# ===========================
# Segment functions
# ===========================


function __raven_start_segment -d 'Start a segment'
  set_color -b $argv[1]
  set_color $argv[2]
  if [ "$current_bg" = 'NONE' ]
    # If there's no background, just start one
    echo -n ' '
  else
    # If there's already a background...
    if [ "$argv[1]" = "$current_bg" ]
      # and it's the same color, draw a separator
      echo -n "$right_arrow_glyph "
    else
      # otherwise, draw the end of the previous segment and the start of the next
      set_color $current_bg
      echo -n "$right_black_arrow_glyph "
      set_color $argv[2]
    end
  end
  set current_bg $argv[1]
end


function __raven_vcprompt_segment -d 'vcprompt segment' 
  set -l vcout  (vcprompt -f "%n/%b/%m/%u/"|sed 's|/|\n|g')
  set -l bg_color $med_red
  set -l fg_color fff
 
  if test (count $vcout) = 5
    
    if test -z $vcout[3]
      set bg_color $lt_green 
      set fg_color $dk_green
    end
    __raven_start_segment $bg_color $fg_color

    switch $vcout[1]
      case git
        printf '±'
      case hg
        printf '☿'
      case svn
        printf '⑆'
    end
    printf ':'$vcout[2]
    
    if test -n $vcout[4]
       printf ' ✗'
    end
    printf ' '

    
  end
  
end




function __raven_virt_segment -d 'virtualenv segment' 
  if test $VIRTUAL_ENV
       __raven_start_segment $malibu $light_sky_blue
       printf (basename $VIRTUAL_ENV)
   end
end


function __raven_path_segment -d 'Display a shortened form of a directory'
  if test -w "$argv[1]"
	      __raven_start_segment $dk_grey $med_grey
	  #	__raven_start_segment 87d7ff 202020
  else
    __raven_start_segment $dk_red $lt_red
  end

if test $PWD = '/'
  printf (set_color normal -b $current_bg)'/'
  return 
end
printf $PWD | sed -r -e 's-([^/]*)$-'(set_color normal -b $current_bg )'\1-g' -e s-^/-@/- -e s-/-$right_arrow_glyph-g -e s-^@-/-


end

function __raven_finish_segments -d 'Close open segments'
  if [ -n $current_bg -a $current_bg != 'NONE' ]
    set_color -b normal
    set_color $current_bg
    echo -n "$right_black_arrow_glyph "
    set_color normal
  end
  set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

function __raven_prompt_status -d 'the symbols for a non zero exit status, root and background jobs'
  set -l nonzero
  set -l superuser
  set -l bg_jobs

  # Last exit was nonzero
  if [ $RETVAL -ne 0 ]
    set nonzero $nonzero_exit_glyph
  end

  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    set superuser $superuser_glyph
  end

  # Jobs display
  set -l numjobs (jobs -l | wc -l)
  if [ $numjobs -gt 0 ]
    set bg_jobs $bg_job_glyph$numjobs' '
  end

  set -l status_flags "$nonzero$superuser$bg_jobs"

  if test "$nonzero" -o "$superuser" -o "$bg_jobs"
    __raven_start_segment fff 000
    if [ "$nonzero" ]
      set_color $med_red --bold
      echo -n $nonzero_exit_glyph
    end

    if [ "$superuser" ]
      set_color $med_green --bold
      echo -n $superuser_glyph
    end

    if [ "$bg_jobs" ]
      set_color $malibu --bold
      echo -n $bg_jobs
    end
  end
end

function __raven_prompt_user -d 'Display actual user if different from $default_user'
  if [ "$theme_display_user" = 'yes' ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      __raven_start_segment $lt_grey $malibu
      echo -n -s (whoami) '@' (hostname | cut -d . -f 1) ' '
    end
  end
end


function __raven_prompt_dir -d 'Display a shortened form of the current directory'
  __raven_path_segment "$PWD"
end





# ===========================
# Apply theme
# ===========================

function fish_prompt
  set -g RETVAL $status

  __raven_prompt_status
  __raven_virt_segment
  __raven_prompt_user
  __raven_prompt_dir
  
  #if type vcprompt  >/dev/null
    __raven_vcprompt_segment
  #else
  #  true #for avoiding the latter error
  #end

  __raven_finish_segments
end
