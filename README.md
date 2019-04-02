# ember-cli docker-compose template

The docker-compose-template is a simple project stub that is useful for starting a new ember project using docker and ember-cli.  It is made up of the following files:

```
ember-project
  docker-compose.yml
  README-template.md
  bash
  ember
  serve
  .bash_history
```

The `docker-compose.yml` is configured to use the [danlynn/ember-cli](https://cloud.docker.com/u/danlynn/repository/docker/danlynn/ember-cli) docker image from dockerhub.

The `bash`, `ember`, and `serve` commands are [shortcuts](#shortcuts) for performing the most common ember dev tasks.


## Example Ember Octane app using this template

  ![ember octane quick start guide tutorial](https://github.com/danlynn/ember-cli-docker-compose-template/blob/gh-pages/ember-cli-octane-demo-anim.gif?raw=true)

  This example runs through the [Quick Start](https://octane-guides-preview.emberjs.com/release/getting-started/quick-start/) ember octane guide tutorial.
  It follows the Quick Start instructions at [ember-cli-docker-compose-template](https://github.com/danlynn/ember-cli-docker-compose-template) for using the [danlynn/ember-cli](https://hub.docker.com/r/danlynn/ember-cli/) docker image with docker-compose.
  
  [Click here](https://danlynn.github.io/ember-cli-docker-compose-template/) to view the video full-size and with playback controls.

## Quick start instructions:

  Copy and run the following 3 lines in your terminal to create a new ember app named 'ember-project' and then host it on [http://locahost:4200](http://locahost:4200):
  
  ```
  $ proj_dir='ember-project' && curl -Ls https://github.com/danlynn/ember-cli-docker-compose-template/archive/master.zip > "$proj_dir.zip" && unzip -qq -j "$proj_dir.zip" -d "$proj_dir" && rm "$proj_dir.zip" && cd "$proj_dir" && mv README.md README-template.md && ls -l
  $ ./ember init
  $ ./serve
  ```

## Slightly more detailed instructions:

  Copy this ember-cli-docker-compose-template dir from github with the following command (replacing "ember-project" at the beginning with the name to use for the new project dir):

  ```
  $ proj_dir='ember-project' && curl -Ls https://github.com/danlynn/ember-cli-docker-compose-template/archive/master.zip > "$proj_dir.zip" && unzip -qq -j "$proj_dir.zip" -d "$proj_dir" && rm "$proj_dir.zip" && cd "$proj_dir" && mv README.md README-template.md && ls -l
  ```

  This creates the following directory structure and cd's into the new project directory.  Note that the README.md was renamed to README-template.md so that it won't conflict with your project's README.md when you init a new ember project:

  ```
  ember-project
    docker-compose.yml
    README-template.md
    bash
    ember
    serve
    .bash_history
  ```

  Verify that the "danlynn/ember-cli:latest" found in docker-compose.yml is using the ember version that you want to use.  Otherwise, change it to something like "danlynn/ember-cli:3.8.1".

  Initialize the ember project using the following command. Note that docker will automagically pull the image if required.  `ember init` takes all the same options as `ember new ember-project` except we don't need to pass the name of the new project directory because it already exists.

  ```
  $ ./ember init
  ```

  Test the newly created app by starting the ember server:

  ```
  $ ./serve
  ```

  Then open the app in your browser:

  [http://locahost:4200](http://locahost:4200)


## Shortcuts

Three super useful shell commands are included in the project directory: `./bash`, `./ember`, `./serve`.  These shortcut commands invoke their corresponding command within the ember docker container specified in the `docker-compose.yml` file.  Note that you MUST type the `./` in front of each command in order to invoke the shortcuts in the project directory instead of a corresponding command installed on your system.

+ `./bash` - open a bash shell in the ember docker container where you can pretty much poke around and do anything you would normally do on the command line.  Note that the history of your bash commands get persisted back into your project's .bash_history file so that you can up-arrow to previous commands on subsequent invocations of the `./bash` shortcut.  Just type `exit` or hit [ctrl-d] to exit the docker container shell and return to your local command line.

  ```
  ember-project$ ./bash

  root@5d2d71453fa3:/myapp# npm list webpack
  myapp@0.0.0 /myapp
  `-- ember-auto-import@1.2.21
    `-- webpack@4.28.4 
  root@5d2d71453fa3:/myapp# exit

  ember-project$ 
  ```

+ `./ember` - run any regular ember command in the ember container.

  ```
  ember-project$ ./ember generate route products
  
  installing route
    create app/routes/products.js
    create app/templates/products.hbs
  updating router
    add route products
  installing route-test
    create tests/unit/routes/products-test.js
  
  ember-project$
  ```
  
+ `./serve` - run the ember server and tail the log.  Hit [ctrl-c] to stop the ember server.

  ```
  ember-project$ ./serve

  Starting ember-project_ember_1 ... done
  Attaching to ember-project_ember_1

  ember_1  | Build successful (5715ms) – Serving on http://localhost:4200/
  ember_1  | 
  ember_1  | 
  ember_1  | Slowest Nodes (totalTime => 5% )              | Total (avg)         
  ember_1  | ----------------------------------------------+---------------------
  ember_1  | Babel: @ember/test-helpers (2)                | 1849ms (924 ms)     
  ember_1  | Rollup (3)                                    | 740ms (246 ms)      
  ember_1  | Package /assets/vendor.js (1)                 | 646ms               
  ember_1  | broccoli-persistent-filter:EslintValid... (2) | 632ms (316 ms)      
  ember_1  | Babel: myapp (3)                              | 409ms (136 ms)      
  ember_1  | Bundler (1)                                   | 302ms               
  ember_1  | ember-auto-import-analyzer (3)                | 290ms (96 ms)       
  ember_1  | 
  
  ^c
  Killing ember-project_ember_1  ... done
  
  ember-project$
  ```


## docker-compose.yml

The `docker-compose.yml` file is setup as follows:

```
version: '2'

services:
  ember:
    image: danlynn/ember-cli:latest
    volumes:
      - .:/myapp
      - .bash_history:/root/.bash_history
      - node_modules:/myapp/node_modules
    tmpfs:
      - /myapp/tmp
    ports:
      - "4200:4200"
      - "7020:7020"
      - "7357:7357"

volumes:
  node_modules:
```

Note that the `node_modules` directory is "volumized".  This means that the thousands upon thousands of tiny files are kept in a docker volume which provides about 10x the performance than if the that directory was shuttled back and forth to a host volume (like all the other source).  This is also why the `node_modules` directory looks blank to your host machine.

If your IDE really, really needs to see the files in `node_modules` in order to work correctly, then you could simply remove the `- node_modules:/myapp/node_modules` line from the `docker-compose.yml` file.  This will cause a considerable performance penalty, however.

The `tmp` directory is similarly setup in a special `tmpfs` volume.  This means that those files are cleared away after the container is stopped.  There is really no need to take up space persisting those files in your host filesystem or as a docker volume.


## Annihilation

In case you want to blow away ALL docker-related assets associated with your project (containers, images, volumes, etc) and start over, you can ***with great care*** execute the following:

```
$ docker-compose down -v --rmi all
```

If you receive an error at the end of the output of this command that looks like the following, simply ignore it.  It just means that docker skipped deleting the image because it is currently being used by another project on your machine.  All the other docker assets related to this docker-compose project were still successfully removed:

```
Removing test_ember_run_63bdca944a7c ... done
Removing test_ember_1                ... done
Removing network test_default
Removing volume test_node_modules
Removing image danlynn/ember-cli:3.8.1
ERROR: Failed to remove image for service ember: 409 Client Error: Conflict ("b'conflict: unable to remove repository reference "danlynn/ember-cli:3.8.1" (must force) - container 878a05646304 is using its referenced image f1daac6795bc'")
```

Note that this WILL NOT touch any of your source!  But, it will clear out the node_modules.  Before running `./ember` or `./serve` commands, you will need to first re-install all the node_module dependencies with:

```
$ ./bash
# npm install
```
