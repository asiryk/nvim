local dir = vim.fn.stdpath("data") .. "/qflists"

local function ensure_dir()
  vim.fn.mkdir(dir, "p")
end

local function filepath(name)
  return dir .. "/" .. name .. ".json"
end

local function list_saved()
  ensure_dir()
  local names = {}
  for _, path in ipairs(vim.fn.glob(dir .. "/*.json", false, true)) do
    table.insert(names, vim.fn.fnamemodify(path, ":t:r"))
  end
  return names
end

local function save(name)
  ensure_dir()
  local items = vim.fn.getqflist()
  if #items == 0 then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    return
  end

  local entries = {}
  for _, item in ipairs(items) do
    table.insert(entries, {
      filename = vim.api.nvim_buf_get_name(item.bufnr),
      lnum = item.lnum,
      col = item.col,
      text = item.text,
      type = item.type,
    })
  end

  local json = vim.json.encode(entries)
  local path = filepath(name)
  local f = io.open(path, "w")
  if not f then
    vim.notify("Failed to write " .. path, vim.log.levels.ERROR)
    return
  end
  f:write(json)
  f:close()
  vim.notify("Saved quickfix list: " .. name .. " (" .. #entries .. " items)")
end

local function load(name)
  local path = filepath(name)
  local f = io.open(path, "r")
  if not f then
    vim.notify("No saved quickfix list: " .. name, vim.log.levels.ERROR)
    return
  end
  local json = f:read("*a")
  f:close()

  local entries = vim.json.decode(json)
  vim.fn.setqflist({}, " ", { title = name, items = entries })
  vim.cmd("copen")
  vim.notify("Loaded quickfix list: " .. name .. " (" .. #entries .. " items)")
end

local function delete(name)
  local path = filepath(name)
  if vim.fn.filereadable(path) == 0 then
    vim.notify("No saved quickfix list: " .. name, vim.log.levels.ERROR)
    return
  end
  os.remove(path)
  vim.notify("Deleted quickfix list: " .. name)
end

local function complete_saved(_, cmdline, _)
  return list_saved()
end

vim.api.nvim_create_user_command("QFSave", function(opts)
  local name = opts.args
  if name == "" then
    vim.ui.input({ prompt = "Quickfix list name: " }, function(input)
      if input and input ~= "" then save(input) end
    end)
  else
    save(name)
  end
end, { nargs = "?", desc = "Save current quickfix list" })

vim.api.nvim_create_user_command("QFLoad", function(opts)
  local name = opts.args
  if name == "" then
    local names = list_saved()
    if #names == 0 then
      vim.notify("No saved quickfix lists", vim.log.levels.WARN)
      return
    end
    vim.ui.select(names, { prompt = "Load quickfix list:" }, function(choice)
      if choice then load(choice) end
    end)
  else
    load(name)
  end
end, { nargs = "?", complete = complete_saved, desc = "Load a saved quickfix list" })

vim.api.nvim_create_user_command("QFDelete", function(opts)
  local name = opts.args
  if name == "" then
    local names = list_saved()
    if #names == 0 then
      vim.notify("No saved quickfix lists", vim.log.levels.WARN)
      return
    end
    vim.ui.select(names, { prompt = "Delete quickfix list:" }, function(choice)
      if choice then delete(choice) end
    end)
  else
    delete(name)
  end
end, { nargs = "?", complete = complete_saved, desc = "Delete a saved quickfix list" })
