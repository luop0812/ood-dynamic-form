## Create the template form

The file 'template.yml.erb' serves as a template to generate the real application forms.  
First, you need to edit the 'form' and 'attribute' secitons of template.yml.erb. You need 
to make sure that the entries in 'form' are what you want to be shown in application forms 
and the attributes of each form entry are what you want them to be.

The key parts of the template file are the two segments of ruby code embeded into the yml file
that does the trick.

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

## Setup

Create a list of Apps you want to use the dynamic module listing and put them into app.list, one App a line. 

Now run this command  
>sudo ./setup.sh -p path -f app.list

What the setup.sh script does is to generate a form.yml.erb for every App listed in app.list
and copy it to /var/www/ood/apps/sys/app_name. If there is form.yml existing, it will rename it as form.yml.bak.

## Module list for the App 

The script generate 

## Cron job


