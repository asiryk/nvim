vim.cmd([[
  aunmenu PopUp
  vnoremenu PopUp.Cut                     "+x
  vnoremenu PopUp.Copy                    "+y
  anoremenu PopUp.Paste                   "+gP
  vnoremenu PopUp.Paste                   "+P
  vnoremenu PopUp.Delete                  "_x
  nnoremenu PopUp.Select\ All             ggVG
  vnoremenu PopUp.Select\ All             gg0oG$
  inoremenu PopUp.Select\ All             <C-Home><C-O>VG
  amenu PopUp.-1-                         <NOP>
  anoremenu PopUp.?\ No\ Git\ Repo        <cmd>lua vim.notify("Not inside Git repository", vim.log.levels.WARN)<CR>
  anoremenu PopUp.Git\ Blame              <cmd>Gitsigns blame<CR>
  anoremenu PopUp.Git\ Blame\ Line        <cmd>Gitsigns blame_line<CR>
  anoremenu PopUp.Git\ Preview\ Hunk      <cmd>Gitsigns preview_hunk<CR>
  anoremenu PopUp.Git\ Diff\ Open         <cmd>DiffviewOpen<CR>
  anoremenu PopUp.Git\ Diff\ Close        <cmd>DiffviewClose<CR>
  anoremenu PopUp.Git\ Diff\ Preset       <cmd>DiffPreset<CR>
  anoremenu PopUp.Git\ Diff\ Hash         <cmd>lua require("plugins.fugitive").open_commit_diff_under_cursor()<CR>
  anoremenu PopUp.Git\ Copy\ Hash         "+yiw
  amenu PopUp.-2-                         <NOP>
  nnoremenu PopUp.Close\ Window           <C-w>q
  nnoremenu PopUp.Split\ Vertical         <C-w>v
  nnoremenu PopUp.Split\ Horizontal       <C-w>s
  "
]])

local F = {}

local group = vim.api.nvim_create_augroup("nvim.popupmenu", { clear = true })

vim.api.nvim_create_autocmd("MenuPopup", {
  group = group,
  desc = "Custom PopUp Menu",
  callback = function(data)
    local bufname = vim.api.nvim_buf_get_name(data.buf)
    local ft = vim.bo[data.buf].filetype
    local cword = vim.fn.expand("<cword>")
    local is_git_buf = vim.b.gitsigns_status_dict ~= nil

    local any_git_menu = false

    do -- Git Gitsigns
      vim.cmd([[amenu disable PopUp.Git\ Blame]])
      vim.cmd([[amenu disable PopUp.Git\ Blame\ Line]])
      vim.cmd([[amenu disable PopUp.Git\ Preview\ Hunk]])
      if is_git_buf then
        vim.cmd([[amenu enable PopUp.Git\ Blame]])
        vim.cmd([[amenu enable PopUp.Git\ Blame\ Line]])
        if F.is_git_hunk() then vim.cmd([[amenu enable PopUp.Git\ Preview\ Hunk]]) end
        any_git_menu = true
      end
    end

    do -- Git Diffview
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Open]])
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Close]])
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Preset]])

      if is_git_buf then
        if require("plugins.diffview").is_diffview_open() then
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Close]])
          any_git_menu = true
        else
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Open]])
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Preset]])
          any_git_menu = true
        end
      elseif bufname:match("^diffview:///") then
        vim.cmd([[amenu enable PopUp.Git\ Diff\ Close]])
        any_git_menu = true
      end
    end

    do -- Git Fugitive
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Hash]])
      vim.cmd([[amenu disable PopUp.Git\ Copy\ Hash]])

      if ft == "git" then
        if cword:match("^%x+$") then
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Hash]])
          vim.cmd([[amenu enable PopUp.Git\ Copy\ Hash]])
          any_git_menu = true
        end
      end
    end

    if any_git_menu then
      vim.cmd([[amenu disable PopUp.?\ No\ Git\ Repo]])
    else
      vim.cmd([[amenu enable PopUp.?\ No\ Git\ Repo]])
    end
  end,
})

function F.is_git_hunk()
  local gitsigns = package.loaded.gitsigns
  if not gitsigns or not gitsigns.get_hunks then return false end

  local hunks = gitsigns.get_hunks()
  if not hunks then return false end

  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

  for _, hunk in ipairs(hunks) do
    if
      cursor_line >= hunk.added.start
      and cursor_line <= (hunk.added.start + hunk.added.count - 1)
    then
      return true
    end
  end

  return false
end
