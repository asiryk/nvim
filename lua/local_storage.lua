--- @class ColorschemeStorage
--- @field name string Name of the colorscheme
--- @field variant string Variant of the colorscheme
---
--- @class Storage
--- @field colorscheme ColorschemeStorage Colorscheme data

local RingBuffer = require("ring_buffer")
local storage_buffer = RingBuffer.new(10)

local function get_file_path()
  return vim.fn.stdpath("data") .. "/user_config.json"
end

local function save_data(filepath, data)
  local file = io.open(filepath, "w")
  if file then
    local content = vim.fn.json_encode(data)
    file:write(content)
    file:close()
  else
    error("Failed to open file " .. filepath)
  end
end

local function load_data(filepath)
  local ok, file_content = pcall(vim.fn.readfile, filepath)
  if ok and #file_content > 0 then
    return vim.fn.json_decode(file_content)
  else
    return {}
  end
end

local function init_storage()
  local path = get_file_path()
  local data = load_data(path)
  storage_buffer:push(data)
end

--- Merges data into current storage object and persist it into
--- json on a filesystem.
--- @param data Storage
local function persist_data(data)
  if storage_buffer:get_size() == 0 then
    vim.notify(
      "local_storage is not initialized. call 'init_storage' first",
      vim.log.levels.ERROR
    )
    return
  end

  local last_data = storage_buffer:get_last()
  last_data = vim.deepcopy(last_data, true)
  local merged = vim.tbl_deep_extend("force", last_data, data)
  local ok = pcall(save_data, get_file_path(), merged)
  if ok then
    storage_buffer:push(merged)
  else
    vim.notify(
      "failed to persist data to file",
      vim.log.levels.ERROR
    )
  end
end

--- Get latest storage data
--- @return Storage storage Latest storage data
local function get_data()
  return storage_buffer:get_last()
end

local M = {}
M.init_storage = init_storage
M.persist_data = persist_data
M.get_data = get_data

return M
