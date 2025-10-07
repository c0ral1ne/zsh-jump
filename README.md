# zsh-jump 🐸
### A simple directory bookmarking plugin for Zsh

**zsh-jump** lets you bookmark and instantly jump between frequently used directories — lightweight, fast, and fully integrated with tab completion.

### 🚀 Features
- Add, jump to, list, and remove directory bookmarks  
- Tab completion for bookmark names  
- Works seamlessly with **Oh My Zsh** or standalone Zsh setups  

## 📦 Installation
### **Oh My Zsh**
1. Clone the repository into your custom plugins directory:
```
git clone https://github.com/c0ral1ne/zsh-jump.git ~/.oh-my-zsh/custom/plugins/zsh-jump
```
2. Add `zsh-jump` to your plugin list in `~/.zshrc`:
```
plugins=(git zsh-jump)
```
3. Reload shell

## Usage
```
Command              Description
-------------------  -----------------------------------------------
ja <name> [path]     Add a bookmark (defaults to current directory
                     if [path] is omitted)
j <name>             Jump to a bookmarked directory
jrm <name>           Remove a bookmark
jls                  List all bookmarks
b                    Go back to the previous directory (cd -)
```

## My todo
- Better error handling
- Fuzzy / partial tab completion
- Overwrite prompt
- Colorized `jls`
