# #!/usr/bin/env bash
# #################################################################################
# # VARIABLES
# ###
# 
# #################################################################################
# # SCRIPT
# ###
# 
# ################################################
# # fancy tree 
# ################################################
tree()
{
	/usr/bin/tree -C -L ${1:-10} | less -R;
}




# ################################################
# # archive git branch 
# ################################################
archive_branch()
{
	git branch -m wip/jco/$1 archive/jco/$1;
	
}



rm_proxy_env ()
{
    export HTTP_PROXY="";
    export HTTPS_PROXY="";
    export http_proxy="";
    export https_proxy=""
}

cs_untar ()
{
    for file in `ls -1`; do
        sudo tar -xf "${file}" ; done
}


cs_120_who ()
{
    ssh dev@192.168.0.120 "cat ~/.gitconfig" | grep -A3 user
}


cs_shotgun ()
{
    list_of_racks="
    conv1      
    conv1ccp   
    conv4      
    conv4ccp   
    conv6      
    conv8      
    conv9      
    conv10     
    conv11     
    conv12     
    conv15     
    conv16     
    conv17     
    conv18     
    conv21
    "

    if [ "$1" != "" ]
    then
        list_of_racks=$1
    fi
    
    echo -n "try to reserve"
    while true; do
        for rack in ${list_of_racks}
        do
            echo -n "."
            _cs_check_rack_availability $rack > /dev/null
            [ $? -eq 0 ] && break 2
        done
        sleep 5
    done
    echo
    cs_reserverack $rack
    echo " Reserved"
    zenity --info --text=$(cs_whogotrack | grep e_jcollo | awk '{print $1}')
}


catlog ()
{
    CHANNEL_FOR_EXE=${2:-"a"};
    LOOP_FOR_EXE=${3:-"short_loop"};
    UNSTRIPPED_EXE="$CSS_ROOT/dist/css-pool/pikeos-native/object/${CHANNEL_FOR_EXE,,}/${LOOP_FOR_EXE}.unstripped";
    head -n -1 $1 | awk -v unstripped_exe=$UNSTRIPPED_EXE -f $AWK_CONFIG_FILE | sed 's/^.* \[//g' | less -R
}


diff_of_module_since_hash ()
{
    USAGE="Usage : ${FUNCNAME[0]} [module_name] [git_hash]"

    MODULE_NAME=$1
    GIT_HASH=$2
    CONTEXT=$3

    if [ -z "$MODULE_NAME" ] || [ -z "$GIT_HASH" ]; then
        error "$USAGE"
        return 2
    fi
 
    if [ -z "$CONTEXT" ]; then
        CONTEXT=5
    fi  

    git diff -U$CONTEXT $GIT_HASH -- $(grep -nRI --files-with-matches --include \*.adb --include \*.ads $MODULE_NAME 2> /dev/null)
}

cs_capture(){
  CHANNEL=${1:-"A"}
  ITF=${2:-"ext0"}
  NB=${3:-"200"}
  cs_ssh $CHANNEL sudo "tcpdump -ni $ITF -c $NB -s 65535 -w /tmp/capture_$CHANNEL.pcap" 
  cs_pull $CHANNEL /tmp/capture_$CHANNEL.pcap /tmp 
  wireshark /tmp/capture_$CHANNEL.pcap
}

kill_reconf() {
  cs_run ALL sudo "pkill -x cs_ws_reconf"
}


findvim() {
  USAGE="Usage : ${FUNCNAME[0]} PATTERN

  PATTERN : name pattern of file to search / open"

  local file_list=$(find -name $@) 
  vim "$file_list"
}
