#!/bin/bash

module_root=
app_list_file=
ood_app_root='/var/www/ood/apps/sys'

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
             echo "Usage: $0 [-p path] [-f app.list]"
             exit 1
             ;;
    esac
done
shift $((OPTIND-1))

if [ -z $module_root ] || [ -z $app_list_file ]; then
    echo "Usage: $0 [-p path] [-f app.list]"
    exit 1
fi

apps=$(more $app_list_file)
for app in $apps; do
    app_root=${ood_app_root}/$app
    if [ ! -d ${app_root} ]; then
        echo "No ${app_root} exists"
        echo "Skip to the next app."
    else
        # generate form.yml.erb for this app
        cp template.yml.erb form.yml.erb
        sed -i "s/__app_name__/$app/g" form.yml.erb
        sed -i "s~__app_root__~$module_root~g" form.yml.erb

        # rename the old form.yml if it exists
        if [ -f ${app_root}/form.yml ]; then
            mv ${app_root}/form.yml ${app_root}/form.yml.bak
        fi 

        # move form.yml.erb to app_root
        #mv form.yml.erb ${app_root}
    fi
done
