return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  event = {
    "BufReadPre /Volumes/knowledge-base/*.md",
    "BufNewFile /Volumes/knowledge-base/*.md",
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "knowledge-base",
        path = "/Volumes/knowledge-base/",
      },
    },
    templates = {
      folder = "Templates",
    },
    completion = {
      blink = true,
      min_chars = 2,
    },
    frontmatter = { enabled = false },
    ui = {
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      hl_groups = {
        ObsidianTodo = { link = "@comment.todo.unchecked" },
        ObsidianDone = { link = "@comment.todo.checked" },
        -- ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        -- ObsidianTilde = { bold = true, fg = "#ff5370" },
        -- ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { link = "@markup.list" },
        ObsidianRefText = { link = "@markup.link.url" },
        ObsidianExtLinkIcon = { link = "@attribute" },
        -- ObsidianTag = { italic = true, fg = "#89ddff" },
        -- ObsidianBlockID = { italic = true, fg = "#89ddff" },
        -- ObsidianHighlightText = { bg = "#75662e" },
      },
    },
  },
}
