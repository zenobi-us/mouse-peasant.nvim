<p align="center">
  <img src="https://github.com/airtonix/mouse-peasant.nvim/assets/61225/a180dce7-1ec6-43cb-bfef-4fc500740168" />
</p>

# Mouse Peasant

> Some haiku about using the mouse
>
> \- Confucious probably

This is the premier config for the discerning Mouse Heretic seeking to use [AstroNvim![Uploading mouse-peasant.png…]()
](https://github.com/AstroNvim/AstroNvim).

## Goals

- Have all the familiar keyboard shortcuts from VScode/Sublimetext (prefer `Ctrl`
  and Arrow keys over old and outdated vimkeys)
- Make [MouseMenu](https://neovim.io/doc/user/gui.html#popup-menu) a first
  class citizen

## Features

- `ctrl + x` and `ctrl + v`: cut and paste everywhere
- `ctrl + shift + up/down`:  moves a line or the selection up or down
- `shift + arrow keys`:  moves to SELECT mode and keeps drawing a highlight
  - `ctrl + shift + left/right`: same but jumps words instead of just characters
- `ctrl + leftclick`: is goto definition
  - `ctrl + shift + -`: goback from definition
- `ctrl + p`: open up a command palette of sorts (`:Telescope keymaps`)
- `ctrl + z`: undo
- `ctrl + shift + z`: redo
- `tab`: indent line or selection
- `shift + tab`: unindent line or selection
- `ctrl + space`: autocomplete menu

## Todo

- `ctrl + p`: Work out how to merge `:Telescope keymaps` with `:Telescope :commands`
- `ctrl + \`: work out how to bind this to AstroNvims comment/uncomment feature

### Mouse Menus

The goal is to have a [MouseMenu](https://neovim.io/doc/user/gui.html#popup-menu)
for all the relevant above items and more.

#### File Menu

Currently there is a menu for NeoTree.

## 🛠️ Installation

### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### Clone AstroNvim

```shell
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
```

### Clone this AstroConfig

```shell
git clone git@github.com:airtonix/mouse-peasant.nvim.git ~/.config/nvim/lua/user
```

### Start Neovim

```shell
nvim
```
