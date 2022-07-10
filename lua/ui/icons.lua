local M = {}

-- alpha 
-- alphabetical 
-- at 
-- asterisk 
-- ban 
-- bars 
-- bolt (flash)   zap ⚡
-- book 
-- bookmark 
-- bug   
-- bullseye  﫜
-- chain 
-- clone 
-- todo test nf-mdi-widgets - enum in intellij
-- close 
-- check   﫟
-- check board 
-- chevron up 
-- fork  branch  commit 
-- format-align-left  -- todo not the same
-- format-size 
-- format-text 
-- format-title 﫳
-- text 
-- cached 
-- cog  (gear)
-- columns 
-- copy 
-- cube      
-- cut  
-- file 
-- files 
-- filter 
-- function 
-- hashtag 
-- hexagon  
-- cursor  﫦
-- textbox ﬍
-- image 
-- info 
-- lightbulb   
-- navicon 
-- square  
-- superscript 
-- tag (label)  
-- tree 
-- underline  
-- equal  
-- layers 
-- molecule 
-- pi 
-- fae-smaller 
-- tools  
-- ruler 
-- mdi-apps 
-- brightness 
-- parentheses  braces  brackets  tags 
-- magnify  -- todo not the same
-- numeric 
-- seti-config 
-- mention 
-- seti-css 
-- seti-ejs 
-- seti-default 
-- seti-json 
-- weather     

M.ui = { -- icons from https://graphemica.com
  ["U258E"] = "▎",
  ["U25B6"] = "▶",
  ["U25B8"] = "▸",
  ["U2B95"] = "⮕",
  ["U2716"] = "✖",
}

M.lspkind = {
  Namespace = "",
  Text = "",
  Method = "", --"",
  Function = "",
  Constructor = "",
  Field = "", --"",
  Variable = "",
  Class = "",
  Interface = "", --"",
  Module = "",
  Property = "", --"",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "", -- "", -- 
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
  Table = "",
  Object = "",
  Tag = "",
  Array = "",
  Boolean = "",
  Number = "",
  Null = "",
  String = "",
  Calendar = "",
  Watch = "",
  Package = "",
}

--local kind_icons = {
--   Text = "",
--   Method = "m",
--   Function = "",
--   Constructor = "",
--   Field = "",
--   Variable = "",
--   Class = "",
--   Interface = "",
--   Module = "",
--   Property = "",
--   Unit = "",
--   Value = "",
--   Enum = "",
--   Keyword = "",
--   Snippet = "",
--   Color = "",
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = "",
--   Constant = "",
--   Struct = "",
--   Event = "",
--   Operator = "",
--   TypeParameter = "",
--}

return M
