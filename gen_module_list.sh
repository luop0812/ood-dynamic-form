#!/bin/bash

module_root=
app_list_file=

# process arguments
while getopts ":p:f:" OPTION; do
    case $OPTION in
        p)
             module_root=$OPTARG
             ;;
        f)
             app_list_file=$OPTARG
             ;;
        *)
             echo "Usage: $0 -p [path] -f [app.list]"
             exit 1
             ;;
    esac
done
shift $((OPTIND - 1))

if [ -z $module_root ] || [ -z $app_list_file ]; then
    echo "Usage: $0 [-p path] [-f app.list]"
    exit 1
fi

apps=$(more $app_list_file)
for app in $apps; do
    app_module_root=${module_root}/$app
    module_file=$app_module_root/modules

    if [ ! -d ${app_module_root} ]; then
        mkdir -p ${app_module_root}
    fi

    # run `module spider` to find all versions for a particular module        
    cmd="module spider $app/ 2>&1 |grep -i \"\ \ \ $app/\" "
    ret=$(eval $cmd)
    # write each version to a file, with the format '- [ "version" ]'
    cat /dev/null > $module_file
    for module in $ret; do
        echo "- [ \"$module\" ]" >> $module_file
    done   
done
