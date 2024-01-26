local M = {}

--- FIXME: make into a dictionary
M.bvar_name_bufnr = "view_nvim_original_bufnr"

---returns the main bufnr from a vim.b[bufnr]
---@param bufnr integer
---@return integer
M.get_main_bufnr = function(bufnr)
  return vim.b[bufnr][M.bvar_name_bufnr]
end

---sets the main bufnr to a vim.b[bufnr]
---@param bufnr integer
---@param main_bufnr integer
M.set_main_bufnr = function(bufnr, main_bufnr)
  vim.b[bufnr][M.bvar_name_bufnr] = main_bufnr
end

---@param bufnr integer
---@param vbuffers_makers view.VBuffersMaker[]
---@return view.VBuffer[]?
M.create_vbuffers = function(bufnr, vbuffers_makers)
  ---@type view.VBuffer[]
  local vbuffers = {}

  -- adding the default vbuffer into the 1st position
  table.insert(vbuffers, 1, { vbuffer_maker_name = "default", bufnr = bufnr })

  for vbuffer_maker_name, vbuffer_maker in pairs(vbuffers_makers) do
    if (vbuffer_maker.is_buf_viewable(bufnr)) then
      local vbufnr = vbuffer_maker.viewer(bufnr)

      if vbufnr and vbufnr ~= 0 and vim.api.nvim_buf_is_valid(vbufnr) then
        table.insert(vbuffers, { vbuffer_maker_name = vbuffer_maker_name, bufnr = vbufnr })
        M.set_main_bufnr(vbufnr, bufnr)
      else
        -- error that creating view buffer has failed
        return nil
      end
    end
  end

  return vbuffers
end

return M
