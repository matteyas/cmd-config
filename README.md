# cmd-config
An automated configuration tool that will setup a reasonable command line environment in Windows.

DISCLAIMER: One change to the registry is required to enable the functionality (HKEY_CURRENT_USER\SOFTWARE \Microsoft\Command Processor\Autorun), cmd-config is not portable in the strictest sense. This is the *only* system-wide footprint.

Here's a list of some of the features ([complete list below](https://github.com/matteyas/cmd-config/blob/master/README.md#macro-usage)):
* `xx` -> closes the command prompt and remembers the path; the next command prompt will spawn at this location
* Quick navigation between "favorite" folders that are remembered between cmd sessions
  1. `cd c:\windows\system32`
  2. `mark sys`
  3. `cd [somewhere else]`
  4. `j sys` → this will take you back to c:\windows\system32 that was marked previously
  5. `jj` → this is a jump-back to the place you were before jumping. `jj` can be used recursively to jump back and forth.
* Some bash inspiration that I personally find more useful than the standard cmd names:
  * `rmrf [dir]` -> removes a directory structure without prompts.
  * `rm [file/files]` -> removes files.
  * `ls` is an alias for `dir`.
  * `cp` is an alias for `copy`.
* Changes the prompt from "path\> " to "path{newline}# ". This may take some time to get used to, but it is a sane change. The input will always be at the same place in relation to the path!
* And most importantly, easy customization. Just type `setup` to edit the script that autoruns at each prompt or `macros` to edit the doskey macros (which enable most of the implemented behavior).

cmd-config has two main parts to accomplish its task: init.cmd and macros.txt

## init.cmd
Note: init.cmd is created by `setup_cmd_autostart.cmd`, to look at a sample script, navigate to [the cmd-config gallery](https://github.com/matteyas/gallery/blob/master/cmd-config/init.cmd)

This script will run whenever a cmd.exe shell is executed. It runs the initial setups of macros and variables for each shell. It uses a specific registry entry (HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun) to autorun on each shell.

*HINT: Note that one of the features in cmd-config is that each new shell can return to the last path that it was closed on (using `xx` to close a shell will make new shells return to the previous path). This __will__ change the behavior of any batch file you launch from Windows, since they will start a new shell before running, thus running in a potentially unexpected path. If one of your scripts fails, use `xxx` to disable the "return to last path" feature.*

## macros.txt
Macro definitions are loaded (in init.cmd) from this file. Note that some macros will only work if running the shell as admin.

## (private_macros.txt)
This is an optional file that I personally use for macros that only work on this computer. You can edit this one by issuing a `pm` command in a shell.

## functions / tools
The "functions" path contains batch scripts for implementing some usability features. The suggested pattern for naming the scripts is function\_[scriptname].cmd and then creating a wrapper in the macros.txt file as such: [scriptname] $* (one may use some other name in the wrapper)

The "tools" path is for enabling useful features with the help of outside programs.

*NOTE: Both the "functions" and "tools" path, just like the cmd-config path, will be in the PATH environment variable. Any tool / function in these paths can thus be used in a shell. Also note that the global user / system PATH variable is not changed; the variable is updated locally in each shell.*

# Setup CMD Environment (macros etc.)
1. clone into some path **without spaces** (might be fixed in future versions)
2. run cmd **as admin** (for registry access)
3. cd into "clone_path\cmd-config"
4. run setup_cmd_autostart.cmd
5. start a new cmd.exe

# Macro Usage
### elevate shell (run as admin)
```
elevate - runs an elevation script that spawns a shell running as admin
```
NOTE: If elevation is successful (pressing yes on the UAC prompt), the previous non-elevated shell will be closed and the elevated one will remain.
### simple looping
```
 loop [expr] [command]    - loop over the files in [expr] and perform [command] on each entry (variable %i)
dloop [expr] [command]    - same as loop, but over directories instead of files
rloop [path] [expr] [cmd] - recursively walk [path] and perform "loop [expr] [cmd]" in each dir
lloop [s] [ds] [e] [cmd]  - loop from [s] to [e] with stepsize [ds], perform [cmd] on each step
floop [opts] [expr] [cmd] - FOR /F "[opts]" %i in ([expr]) do ([cmd])
```
Loop examples are found [near the end](https://github.com/matteyas/cmd-config/blob/master/README.md#loop-examples) of this page.

*NOTE: An unfortunate state of affairs regarding batch (what a surprise) is that macros only work in the local shell. Not even scripts launched in the local shell (with macros enabled) will have access to the macros. This means that `loop *.txt notepad %i` will open all text files in the directory using notepad, but using the macro `edit` instead of `notepad` will not work.*

*This may be worked around in later versions of cmd-config.*
#### Pipes and redirections in loops
Special keywords enable piping and redirection in loops:
```
syntax    batch equivalent
==========================
-pipe-    |
-/-       |

-append-  >>
-a-       >>

-out-     >
-o-       >

-and-     &
-+-       &
```
There are [example use cases](https://github.com/matteyas/cmd-config/#pipes-and-redirections) available below in the loop examples.
### looking at init script and macros
```
setup / alias   - opens the init.cmd script in notepad
macro / macros  - opens macros.txt in notepad
pm              - opens private_macros.txt in notepad
```
### list / reload macros
```
lm  - prints out all the currently defined macros, with some exceptions (macros in init.cmd)
rlm - reload macros from disk (run this after editing macros.txt / private_macros.txt)
```
`list_macros` and `listmacros` are synonyms for `lm`
### Time and benchmarking
```
now       - prints the current date and time
bench cmd - prints time, runs cmd (some demanding batch file for example), prints time
```
### exit console
```
x   - synonym for exit
xx  - exits and saves the current path (next cmd.exe will start in this path)
xxx - exits and removes any previously saved path (next cmd.exe will start in its default location)
```
### file / directory removal
```
rmrf [dir]  - removes directory tree at [dir] without prompts
rmd [dir]   - removes directory tree at [dir] with prompts
rm [args]   - alias for del [args]
```
### computer management
```
advboot - enter advanced (windows) boot menu and restart¹
bios    - restart computer into BIOS / UEFI firmware¹ ²
uefi    - same as bios¹
reboot  - restart computer¹
off     - shut down computer¹
hib     - hibernate computer¹
sleep   - put computer to sleep¹
zzz     - same as sleep¹

abort         - cancel any of the above commands, if remaining time > 0
dontshutdown  - same as abort
keepon        - same as abort

req / reqs    - checks if there are any power requests (that are keeping the computer awake)
lastwake / lw - report on the last cause for waking the computer
```
*¹ Supply an optional numerical argument to specify delay before command execution, the default value is 120 if no argument is given. To specify no delay, input one of the following arguments: now, none, 0. Also, with no delay, passing any second argument makes applications close forcibly (this is the default behavior, which cannot be changed, for delayed shutdown / reboot commands).  
² BIOS / UEFI boot most likely only works if Windows was installed with UEFI enabled.*

Note that all shutdown modes that can forcibly close programs will do so if necessary.
### usability
```
here        - opens explorer in the current shell path
cdd         - creates the directory and then cd's into it (cdd a\b\c\d will create the entire path)
cp          - alias for copy
ls          - alias for dir
xc [args]   - alias for xcopy /C /R /E /Y [args], generates logs for stderr and stdout
get [file]  - copies [file] to the scripts home directory (clone directory)
```
### navigation
```
..  - alias for cd..
... - alias for cd..\.. (e.g. navigate from c:\a\b to c:\)
```
There is support for moving further down the path with more dots, `....` will go down three steps and so on.
```
home        - jumps to script home directory (saves prior path, see the next command)
back        - jumps back to the path in which the home command was issued
```
```
mark [name] - creates a marked location called "name", from the current path
j [name]    - jumps to the previously marked location "name"
jj          - after jumping, this command jumps back to the prior directory before the jump
```
Example, where `b` was created using `mark b` at e:\Batch:
```
e:\replace-text
# j b

e:\Batch
# jj

e:\replace-text
#
```
It's possible to list all marked locations. They will show up as mark_dir\_*[name]* (the `b` used above will show up as `mark_dir_b` for example).
```
marks   - lists marked locations
marked  - same as above
```
### programs
```
sb, st  - launches sublime_text¹, will create / open file if argument is supplied
edit    - launches notepad, will create / open file if argument is supplied
py      - alias for python, will use supplied arguments
ju      - alias for julia, will use supplied arguments
```
*¹ Note that this assumes that sublime 3 is installed in the default path C:\Program Files\Sublime Text 3, or that it is otherwise available in the PATH variable. Use the command `setup` if you want to manually include another location in PATH.*

### git
```
gp  - pull cmd-config updates from git
gup - commit + push cmd-config updates
```

### Loop Examples
#### `loop`
Note that %i is used to access each file looped over:
```dos
E:\git\cmd-config
# loop *.txt echo %i
last_dir.txt
macros.txt
marks.txt
private_macros.txt
```
#### `dloop`
Makes use of [pipes and redirections](https://github.com/matteyas/cmd-config/blob/master/README.md#pipes-and-redirections-in-loops) syntax.
```dos
E:\git\cmd-config
# dloop * (dir %i -pipe- find /V "Volume" -/- find /V "(s)" -append- log.txt)

E:\git\cmd-config
# type log.txt

 Directory of E:\git\cmd-config\functions

2017-02-16  13:45    <DIR>          .
2017-02-16  13:45    <DIR>          ..
2017-02-16  14:58               658 function_dloop.cmd
2017-02-13  12:29             1 541 function_elevate.cmd
2017-02-16  13:44               566 function_floop.cmd
2017-02-15  17:05               475 function_loop.cmd

 Directory of E:\git\cmd-config\tools

2017-02-16  09:42    <DIR>          .
2017-02-16  09:42    <DIR>          ..
2016-06-27  14:11           167 936 unzip.exe
2016-12-20  12:32           356 864 zip.exe
```
#### `lloop`
```
e:\git\cmd-config
# lloop 1 1 3 (echo:-pipe-time)
The current time is: 10:20:23,53
Enter the new time:
The current time is: 10:20:23,56
Enter the new time:
The current time is: 10:20:23,59
Enter the new time:

e:\git\cmd-config
# lloop 1 2 9 echo %i
1
3
5
7
9
```
#### `floop`
```
e:\git\cmd-config
# floop "usebackq delims=" "`tasklist -pipe- find "cmd"`" echo %i
hkcmd.exe                     6500 Console                    1        364 K
cmd.exe                       9356 Console                    1      1 324 K
cmd.exe                      17036 Console                    1      4 024 K
cmd.exe                      17360 Console                    1      3 508 K
```
Note that the first two expressions, options and the expression looped over, are enclosed in "" since they contain spaces. The last block—the do-block, or cmd-block—cannot be enclosed in "".
#### Pipes and redirections
Examples:
```dos
E:\git\cmd-config
# (echo:>_test1.txt) & (echo:>_test2.txt)

:: note that the -out-%i in the following command is the same as >%i
E:\git\cmd-config
# loop _*.txt echo processing %i... -+- echo This is the contents of file %i -out-%i
processing _test1.txt...
processing _test2.txt...

E:\git\cmd-config
# loop _*.txt echo contents of %i^: -+- echo.¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ -+- type %i -+- echo.
contents of _test1.txt:
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This is the contents of file _test1.txt

contents of _test2.txt:
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
This is the contents of file _test2.txt
```
```dos
E:\git\cmd-config
# dloop * (dir %i -pipe- find /V "Volume" -/- find /V "(s)" -append- log.txt)

E:\git\cmd-config
# type log.txt

 Directory of E:\git\cmd-config\functions

2017-02-16  13:45    <DIR>          .
2017-02-16  13:45    <DIR>          ..
2017-02-16  14:58               658 function_dloop.cmd
2017-02-13  12:29             1 541 function_elevate.cmd
2017-02-16  13:44               566 function_floop.cmd
2017-02-15  17:05               475 function_loop.cmd

 Directory of E:\git\cmd-config\tools

2017-02-16  09:42    <DIR>          .
2017-02-16  09:42    <DIR>          ..
2016-06-27  14:11           167 936 unzip.exe
2016-12-20  12:32           356 864 zip.exe
```
