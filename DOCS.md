# Documentation

- [💭 In General](#in_general)
- [✏️ Creating New Recipes](#creating_new_recipes)
- [🏗️ Building the Template](#building_the_template)

<div id="in_general"/>

## 💭 In General

Rezeptig consists of three .tex-files: "recipebook", "recipe_env", and 
"recipe_bp".

The first file, "recipebook", is the main file. This file contains all 
configurations as well as the document, including the title and date pages. The 
"recipe_env" file defines the layout of a recipe as a new document environment. 
The last file, "recipe_bp", contains the blueprint with placeholders for new 
recipes.

Rezeptig saves all custom recipes linearly as .tex-files in the "recipes" 
folder, although this name can be customized in the Makefile. In general, all 
file names can be customized as long as they are consistent with the header in 
the Makefile.

<div id="creating_new_recipes"/>

## ✏️ Creating New Recipes

Creating a new recipe involves the `make new` target. This always creates a new
recipe file in the "recipes" folder and copies the blueprint from "recipe_bp" 
there. If the "recipes" folder doesn't already exist, it will be created.

```
make new [name=awesome_recipe]
```

Specifying a file and recipe name is optional. If no name exists, the file name 
is chosen according to the following naming scheme:

```
recipe-YYYY-MM-DDThh:mm:ss±hhmm
```

The `date` utility is used to determine the timestamp. If a name is specified, 
the new recipe file is named after it. To specify names with spaces, quotes can
be used, as is common in the shell. 
 
```
make new name="awesome recipe"
``` 
 
If quotes are omitted and spaces are used, the recipe file will be named after 
only the first word, while the remaining words are ignored. If a recipe file 
with the same name already exists, the recipe file is named according to the 
above scheme instead.

Finally, the instruction to include the new recipe in the main file is written 
to the ".recipes" file. If this file didn't exist previously, it is created. The 
instruction to include the recipe file is not written directly to the main file, 
because, unlike the recipe files, this file is under source control. This 
prevents the main file's history from being accidentally contaminated with your 
own recipe files.

Note that the timestamp is accurate to seconds. This means that `make new` 
should be called no more than once per second. If the command is called more 
than once, the previously created file with the timestamp will be overwritten by 
the new one. Despite of this, an additional include statement will be added to 
the ".recipes" file each time, resulting in this recipe appearing multiple times 
in the recipe book. **Just don't spam `make new`!** 😇

<div id="building_the_template"/>

## 🏗️ Building the Template

Building the recipe book includes the `make build` target, although specifying 
the target is optional.

```
make [build]
```

First, all instructions for including the recipes from the ".recipes" file are 
sorted alphabetically by file name and written to the ".recipes_build" file. 
Therefore, it is advisable to name the recipe file the same as the recipe 
itself. Otherwise, the recipes in the recipe book may not be alphabetically 
sorted.

Next, a copy of the main file is created (by default, the copy is named 
"recipebook_build"), and the alphabetically sorted instructions from 
".recipes_build" are inserted into it. This copy is created to prevent the main 
"recipebook" file, which is under source control, from being contaminated with 
the instructions for including your own recipe files. If the ".recipes" file did 
not exist previously, it is created.

Finally, the recipe book is built with XeLaTeX. The command is executed twice to 
generate the table of contents.

Before starting another build, the artifacts from the previous one must be 
cleaned up with `make clean`. This removes not only the LaTeX auxiliary files 
but also the ".recipes_build" and ".recipebook_build" files. The original files 
and recipe files are retained.

If you're using VSCode with the 
[Latex Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) 
extension, you can also use it for building. The local settings.json file 
already contains the necessary configuration. To enable automatic building via 
the extension, simply remove the following line from the settings.json file:

```json
"latex-workshop.latex.autoBuild.run": "never",
```

Note that in this case you will need to save the main file twice (because of the 
table of contents) and manually copy the include instructions into the main 
file.
