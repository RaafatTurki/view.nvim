# View.nvim
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

Your buffers from a different perspective.

Switch viewing modes of buffers.
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
require 'view'.select()   -- list all available views
```
or their vim cmds
```
:ViewNext
:ViewPrev
:ViewSelect
```
providing a bufnr to any of the above will preform that action on the associated buffer.

## Config
```lua
-- example config, no defaults
require 'view'.setup {
  viewers = {
    hex = { -- views binary files in hex
      is_buf_viewable = require "hex".view.is_buf_viewable
      viewer = require "hex".view.viewer({
        -- hex viewer opts
      })
    },

    -- other (concept) viewers could be specified here:

    -- views sensitive (.env) files as a lockscreen that requires a confirmation
    lock = {
      is_buf_viewable = ...
      viewer = ...
    },

    -- views image files as ascii art or rendered in kitty protocol
    image = {
      is_buf_viewable = ...
      viewer = ...
    },

    -- views buffers that aren't text and weren't viewable by any of the above
    -- as a centered "Buffer Not Supported!" text instead of gibberish
    unsupported = {
      is_buf_viewable = ...
      viewer = ...
    },
  }
}
```
