# View.nvim
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A canvas to render buffers on in many ways.

This is a helper plugin to switch viewing modes of nvim buffers.

![demo]()

## Install
```lua
{ 'RaafatTurki/view.nvim' }
```

## Setup
```lua
require 'view'.setup {
  -- see configs section
}
```

## Use
```lua
require 'view'.next()     -- switch to next view
require 'view'.prev()     -- switch to previous view
require 'view'.default()    -- switch to default view
```
or their vim cmds
```
:ViewNext
:ViewPrev
:ViewDefault
```
providing a bufnr to any of the above will preform that action on the associated buffer.


## Config
```lua
-- defaults
require 'hex'.setup {
  viewers = {}
}
```
