## Create the template form

The file `template.yml.erb` serves as a template to generate the real application forms. 
First, you need to edit the 'form' and 'attribute' secitons of `template.yml.erb`. You need 
to make sure that each form entry and its attributes are what you want.

The key parts of the template file are the two segments of ruby code embeded into the yml file
that do the trick.

```
<%-
app_name = __app_name__
app_root = __app_root__+app_name
-%>
```
```
    label: <%= app_name %> version
    options:
      <% IO.foreach(app_root+"/modules") do |line| %>
      - <%= line %>
      <% end %>
```

`__app_name__` and `__app_root__` are just place holder and will be replaced with real App name 
and the actual root location of all the module list files after `setup.sh` is run.

## Setup

Create a list of Apps you will deploy with the dynamic module listing scheme and put them into a file called `app.list`, one App a line. 

Now run this command  
>sudo ./setup.sh -p path -f app.list

What `setup.sh` does is to generate a form.yml.erb for every App listed in app.list
and copy it to `/var/www/ood/apps/sys/app_name`. If there is a `form.yml` existing, it will be renamed as `form.yml.bak`.

`path` is a parameter for the root path where all the module list files are stored. In the following example, `path` will be `/usr/local/ood-dynamic-module-list`.
```
/usr/local/ood-dynamic-module-list
├── abaqus
│   └── modules
├── ansys
│   └── modules
└── comsol
    └── modules
```

## Module list for the Apps 

Now run the module list generator 

>sudo gen_module_list.sh -p path -f app.list

This script will actually generate the module list files as shown in the above example. 

## Cron job

To automate the module list generation, you need to create a cron job which runs `gen_module_list.sh` once every day. 
