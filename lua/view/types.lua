-- provided by other plugins in order to provide alternative buffers that represent altenate views of the buffer in question
---@class VBuffersMaker
---@field public is_buf_viewable function(bufnr: integer): boolean
---@field public make_view_buffer function(bufnr: integer): integer

-- one or more of this will be returned by the make_view_buffer() within VBuffersMaker.
-- each one holds the name of the VBuffersMaker that made it,
-- and bufnr of an alternative buffer that represent an altenate view of some buffer
---@class VBuffer
---@field public vbuffer_maker_name string
---@field public bufnr integer

-- a data structure that is single-buffer scoped, it holds all its vbuffers and the index of the currently viewed one
---@class VBufferData
---@field public vbuffers VBuffer[]
---@field public current_vbuffer_i integer
