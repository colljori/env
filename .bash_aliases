alias cls="echo -en '\ec'"
alias makepike="pushd .;cd /home/dev/ouroboros/css/src/pikeos/middleware/core_main; make install; cd /home/dev/ouroboros/css/appli/top; make install; popd; Cs_build_image_with_md5"
alias h=" history | grep -v '^ *[0-9]* *hists' | grep $@"
#alias cs_local_analyze="reset && head -n ${2:--0} ${1:-~/css_sl.log.lastrun}  | awk -f /home/dev/ouroboros/tools/scripts/analyse_trace.awk"
#alias cs_a="reset && tmux clear-history && awk -f /home/dev/ouroboros/tools/scripts/analyse_trace.awk -- ${1}"
#alias cs_full="cs_make_stimuli_file Fdio_Nominal && cs_deploy_project_parameters /home/dev/ouroboros/css/configuration/project_parameters/project_parameters_100_no_board.bin && cs_desinhib && cs_build_and_deploy_css && tmux clear-history && cs_reset && sleep 40 && cs_pull ${1:-A} /var/log/css_sl.log ~/css_sl.log.lastrun && reset && tmux clear-history && tput bel && head -n -0 ~/css_sl.log.lastrun | awk -f '$TOOLS_ROOT'/scripts/analyse_trace.awk"
alias makei='(cd /home/dev/ouroboros/css/src/pikeos/middleware/core_main/ && make install)'
alias makec='(cd /home/dev/ouroboros/css/src/pikeos/middleware/core_main/ && make clean)'
alias maked='(cd /home/dev/ouroboros/css/demo/top/ && make install)'
alias cs_full_clean='(cd /home/dev/ouroboros/css/src/pikeos/middleware/core_main/ && make clean ; make full-clean) ; (cd /home/dev/ouroboros/css/appli/top/ && make clean)'
alias demo="makei && maked && cs_build_boot_image_with_md5 minirack && cs_deploy_boot_image && cs_reset && cs_analyzelogs A sl"
alias cs_source="source ~/.bashrc"
alias clean_ssh="pkill -x ssh"
alias gdb_css_sl="/opt/gnatpro-aarch64/bin/aarch64-elf-gdb /home/dev/ouroboros/css/appli/short_loop/exe/short_loop.unstripped"

alias watch_cs="watch bash -ic \"$@\""
alias cs_clang="git add -u && git clang-format && git reset"

alias GO2SDK='cd ${CSS_ROOT}/src/pikeos/middleware/core_main'
alias GO2APPLI='cd ${CSS_ROOT}/appli/top'
alias GO2DEMO='cd ${CSS_ROOT}/demo/top'

# this alias file is a mess. Anything below is meant to not be a mess
# this part should be the usefull aliases in every environment
alias sgrep="grep -nRI -- $@ 2> /dev/null"
alias sgrep_source="grep -nRI --include \*.h --include \*.c --include \*.adb --include \*.ads -- $@ 2> /dev/null"
alias sgrep_color="grep -nRI --color=always --include \*.h --include \*.c --include \*.adb --include \*.ads -- $@ 2> /dev/null"

alias cs_less="cs_analyzelogs A sl -n 0 -f $@ | less -R"
alias toto="echo \$1 && echo double \$1 && echo triple \$1"

alias cs_add_obs_ip='ip a show dev tun0 | grep -Eo 12[1-9] | xargs printf "ip a add 10.65.201.%d/24 dev eth1" | xargs ssh -F $SSH_CONFIG_FILE edgerouter ; ip a show dev tun0 | grep -Eo 12[1-9] | xargs printf "ip a add 10.69.201.%d/24 dev eth2" | xargs ssh -F $SSH_CONFIG_FILE edgerouter'
alias cs_del_obs_ip='ip a show dev tun0 | grep -Eo 12[1-9] | xargs printf "ip a del 10.65.201.%d/24 dev eth1" | xargs ssh -F $SSH_CONFIG_FILE edgerouter ; ip a show dev tun0 | grep -Eo 12[1-9] | xargs printf "ip a del 10.69.201.%d/24 dev eth2" | xargs ssh -F $SSH_CONFIG_FILE edgerouter'
