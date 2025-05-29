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

local group = vim.api.nvim_create_augroup("nvim.popupmenu", { clear = true })

vim.api.nvim_create_autocmd("MenuPopup", {
  group = group,
  desc = "Custom PopUp Menu",
  callback = function(data)
    local bufname = vim.api.nvim_buf_get_name(data.buf)
    local ft = vim.bo[data.buf].filetype
    local cword = vim.fn.expand("<cword>")
    local is_git_buf = vim.b.gitsigns_status_dict ~= nil

    do -- Git Diffview
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Open]])
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Close]])
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Preset]])

      if is_git_buf then
        if require("plugins.diffview").is_diffview_open() then
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Close]])
        else
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Open]])
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Preset]])
        end
      elseif bufname:match("^diffview:///") then
        vim.cmd([[amenu enable PopUp.Git\ Diff\ Close]])
      end
    end

    do -- Git Fugitive
      vim.cmd([[amenu disable PopUp.Git\ Diff\ Hash]])
      vim.cmd([[amenu disable PopUp.Git\ Copy\ Hash]])

      if ft == "git" then
        if cword:match("^%x+$") then
          vim.cmd([[amenu enable PopUp.Git\ Diff\ Hash]])
          vim.cmd([[amenu enable PopUp.Git\ Copy\ Hash]])
        end
      end
    end
  end,
})
