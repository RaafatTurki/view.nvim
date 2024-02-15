local utils = require 'view.utils'
local augroup_view = vim.api.nvim_create_augroup('view.nvim', {})

local M = {}

---@class view.Config
M.cfg = {
  ---@type {[string]: view.VBuffersMaker}
  viewers = {}
}

---@type view.VBufferData[]
M.bufs_data = {}

---sets up plugin auto commands
local setup_auto_cmds = function()
  vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = augroup_view,
    callback = function(ev)
      local bufnr = ev.buf

      if utils.get_main_bufnr(bufnr) then
        -- do nothing
      else
        -- create the vbuffers
        local vbuffers = utils.create_vbuffers(bufnr, M.cfg.viewers)
        if not vbuffers then
          -- warn that the provided create_vbuffers was faulty
          return
        elseif #vbuffers == 1 then
          -- the provided create_vbuffers created zero views (other than default)
          return
        end

        M.set_buf_data(bufnr, {
          vbuffers = vbuffers,
          current_vbuffer_i = 1
        })
        utils.set_main_bufnr(bufnr, bufnr)
      end

    end
  })
end

---gets the buffer data for a given original bufnr
---@param bufnr_original integer
---@return view.VBufferData
M.get_buf_data = function(bufnr_original)
  return M.bufs_data[bufnr_original]
end

---sets the buffer data for a given original buffer
---@param bufnr_original integer
---@param data view.VBufferData
M.set_buf_data = function(bufnr_original, data)
  M.bufs_data[bufnr_original] = data
end

---switches to the next vbuffer for bufnr
---@param bufnr integer
M.next = function(bufnr)
  -- work on the current buffer if no bufnr is given
  bufnr = bufnr or 0

  -- switch to the next vbuffer
  if vim.api.nvim_buf_is_valid(bufnr) then
    local bufnr_original = utils.get_main_bufnr(bufnr)
    local buf_data = M.get_buf_data(bufnr_original)
    if not buf_data then
      -- warn this buffer has no viewers
      return
    end

    -- get, inc, loop if needed and set the current_vbuffer_i
    local current_vbuffer_i = buf_data.current_vbuffer_i
    current_vbuffer_i = current_vbuffer_i + 1
    if current_vbuffer_i > #buf_data.vbuffers then current_vbuffer_i = 1 end
    buf_data.current_vbuffer_i = current_vbuffer_i

    -- switch to current_vbuffer_i buffer
    vim.api.nvim_win_set_buf(0, buf_data.vbuffers[current_vbuffer_i].bufnr)
  end
end
vim.api.nvim_create_user_command('ViewNext', function(opts) M.next(opts.fargs[0]) end, { nargs = '?' })


---switches to the previous vbuffer for bufnr
---@param bufnr integer
M.prev = function(bufnr)
  -- work on the current buffer if no bufnr is given
  bufnr = bufnr or 0

  -- switch to the previous vbuffer
  if vim.api.nvim_buf_is_valid(bufnr) then
    local bufnr_original = utils.get_main_bufnr(bufnr)
    local buf_data = M.get_buf_data(bufnr_original)
    if not buf_data then
      -- warn this buffer has no viewers
      return
    end

    -- get, dec, loop if needed and set the current_vbuffer_i
    local current_vbuffer_i = buf_data.current_vbuffer_i
    current_vbuffer_i = current_vbuffer_i - 1
    if current_vbuffer_i < 1 then current_vbuffer_i = #buf_data.vbuffers end
    buf_data.current_vbuffer_i = current_vbuffer_i

    -- switch to current_vbuffer_i buffer
    vim.api.nvim_win_set_buf(0, buf_data.vbuffers[current_vbuffer_i].bufnr)
  end
end
vim.api.nvim_create_user_command('ViewPrev', function(opts) M.prev(opts.fargs[0]) end, { nargs = '?' })


---lists all vbuffers for bufnr and switches to one
---@param bufnr integer
M.select = function(bufnr)
  -- work on the current buffer if no bufnr is given
  bufnr = bufnr or 0

  -- list all vbuffers
  if vim.api.nvim_buf_is_valid(bufnr) then
    local bufnr_original = utils.get_main_bufnr(bufnr)
    local buf_data = M.get_buf_data(bufnr_original)
    if not buf_data then
      -- warn this buffer has no viewers
      return
    end

    vim.ui.select(buf_data.vbuffers,
      {
        prompt = "View",
        format_item  = function(vbuffer)
          return vbuffer.vbuffer_maker_name
        end
      },
      function(vbuffer)
        if not vbuffer then return end
        vim.api.nvim_win_set_buf(0, vbuffer.bufnr)
        buf_data.current_vbuffer_i = vbuffer.bufnr
      end
    )
  end
end
vim.api.nvim_create_user_command('ViewSelect', function(opts) M.select(opts.fargs[0]) end, { nargs = '?' })

---plugin setup
---@param args view.Config
M.setup = function(args)
  M.cfg = vim.tbl_deep_extend("force", M.cfg, args or {})

  setup_auto_cmds()
end

return M
