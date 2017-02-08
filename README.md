# cmd-config
This is a configuration that will setup a reasonable command line environment. It has two main parts: init.cmd and macros.txt

## init.cmd
This script will run whenever a cmd.exe shell is executed. It runs the initial setups of macros and variables for each shell. It uses a specific registry entry (HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun) to autorun on each shell.

Disclaimer: Note that one of the features in cmd-config is that each new shell can return to the last path that it was closed on (using `xx` to close a shell will make new shells return to the previous path). This *will* change the behavior of any batch file you launch from Windows, since they will start a new shell before running, thus running in a potentially unexpected path. If one of your scripts fails, use `xxx` to disable the "return to last path" feature.

## macros.txt
Macro definitions are loaded (in init.cmd) from this file.

# Setup CMD Environment (macros etc.)
1. clone into some path *without spaces*.
2. start admin cmd.
3. cd into "clone_path\cmd-config"
4. run setup_cmd_autostart.cmd
5. start a new cmd.exe

# Macro Usage
### looking at init script and macros
```
setup / alias  - opens the init.cmd script in notepad
macro / macros - opens macros.txt in notepad
```
### listing macros
```
lm - prints out all the currently defined macros, with some exceptions (macros in init.cmd)
list_macros and listmacros are synonyms for lm
```
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
### useful common commands
```
ls            - alias for dir
xc [args]     - issues xcopy /C /R /E /Y [args] command with logging of errors and any file operations in separate log files
get [file]    - copies [file] to the scripts home directory (clone directory)
home, back  - jumps to script home directory (and back again)
```
### navigation
```
.. - alias for cd..
..., ...., etc will cd to lower paths, ... will go up two steps and .... will go up three steps (from e.g. c:\a\b\c to c:\)

mark [name] creates a marked location called "name", from the current path
j [name]    jumps to the previously marked location "name"
jj          jumps back to previous directory after jumping
```
Example, where b was created using mark b at e:\Batch:
```
e:\replace-text
# j b

e:\Batch
# jj

e:\replace-text
#
```
### programs
```
sb, st  - launches sublime_text (assuming it is on the path), will create file if argument is supplied
edit    - launches notepad, will create file if argument is supplied
py      - alias for python, will use supplied arguments
```
