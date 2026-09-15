-- Debugging: nvim-dap talks the Debug Adapter Protocol, nvim-dap-view is the UI.
--
-- Rust goes through codelldb (installed by mason, see lua/plugins/lsp.lua).
-- Start with `<Leader>dc` in a Rust buffer: it builds, launches, and opens the
-- dap-view panel; the panel closes again when the program exits.

local dap = require("dap")
local dap_view = require("dap-view")

dap_view.setup({
  -- Open the panel when a session starts and close it when all sessions end.
  auto_toggle = true,
  -- Show variable values inline next to the code while stopped.
  virtual_text = { enabled = true },
})

-- Palette-agnostic: reuse the diagnostic sign colors of the active theme.
for name, sign in pairs({
  DapBreakpoint = { text = "●", texthl = "DiagnosticSignError" },
  DapBreakpointCondition = { text = "◆", texthl = "DiagnosticSignWarn" },
  DapLogPoint = { text = "◉", texthl = "DiagnosticSignInfo" },
  DapBreakpointRejected = { text = "○", texthl = "DiagnosticSignHint" },
  DapStopped = { text = "→", texthl = "DiagnosticSignOk", linehl = "CursorLine" },
}) do
  vim.fn.sign_define(name, sign)
end

-- ─────────────────────────── Rust ────────────────────────────────────────────

-- codelldb ≥ 1.11 speaks DAP over stdio, so nvim-dap can spawn it directly.
-- `codelldb` resolves through mason's bin dir, which mason puts on PATH.
dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb",
}

local function cargo_root() return vim.fs.root(0, "Cargo.toml") or vim.fn.getcwd() end

-- nvim-dap never builds anything, so a plain `program` path would silently
-- debug a stale binary. This runs `cargo build` first and resolves to the
-- executable it produced.
--
-- Returning a coroutine lets the build run without freezing the editor:
-- nvim-dap waits until we resume `dap_run_co` with the program path, or with
-- `dap.ABORT` to cancel the launch.
local function cargo_build_program()
  return coroutine.create(function(dap_run_co)
    local function finish(program)
      vim.schedule(function() coroutine.resume(dap_run_co, program) end)
    end

    vim.notify("cargo build…", vim.log.levels.INFO)
    vim.system(
      -- The JSON messages on stdout name the built executables; human-readable
      -- compiler errors still go to stderr.
      { "cargo", "build", "--message-format=json-render-diagnostics" },
      { cwd = cargo_root(), text = true },
      function(result)
        if result.code ~= 0 then
          vim.schedule(
            function() vim.notify("cargo build failed:\n" .. result.stderr, vim.log.levels.ERROR) end
          )
          return finish(dap.ABORT)
        end

        local executables = {}
        for line in result.stdout:gmatch("[^\n]+") do
          local ok, msg = pcall(vim.json.decode, line)
          if
            ok
            and msg.reason == "compiler-artifact"
            and type(msg.executable) == "string"
            and vim.list_contains(msg.target.kind, "bin")
          then
            table.insert(executables, msg.executable)
          end
        end

        if #executables == 0 then
          vim.schedule(
            function() vim.notify("cargo build produced no binary to debug", vim.log.levels.ERROR) end
          )
          return finish(dap.ABORT)
        elseif #executables == 1 then
          return finish(executables[1])
        end

        vim.schedule(function()
          vim.ui.select(executables, {
            prompt = "Binary to debug",
            format_item = function(path) return vim.fs.basename(path) end,
          }, function(choice) coroutine.resume(dap_run_co, choice or dap.ABORT) end)
        end)
      end
    )
  end)
end

dap.configurations.rust = {
  {
    name = "Build and debug (cargo)",
    type = "codelldb",
    request = "launch",
    program = cargo_build_program,
    cwd = cargo_root,
    -- Loads rustc's LLDB formatters, so String/Vec/Option show their values
    -- instead of raw internal structs.
    sourceLanguages = { "rust" },
  },
}

-- ─────────────────────────── Keymaps ─────────────────────────────────────────

local function set(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc }) end

set("n", "<Leader>db", dap.toggle_breakpoint, "Toggle breakpoint [DAP]")
set("n", "<Leader>dB", function()
  vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
    if condition and condition ~= "" then dap.set_breakpoint(condition) end
  end)
end, "Conditional breakpoint [DAP]")
set("n", "<Leader>dc", dap.continue, "Start / continue [DAP]")
set("n", "<Leader>dn", dap.step_over, "Step over [DAP]")
set("n", "<Leader>di", dap.step_into, "Step into [DAP]")
set("n", "<Leader>do", dap.step_out, "Step out [DAP]")
set("n", "<Leader>dr", dap.run_to_cursor, "Run to cursor [DAP]")
set("n", "<Leader>dl", dap.run_last, "Run last [DAP]")
set("n", "<Leader>dq", dap.terminate, "Terminate [DAP]")
set("n", "<Leader>du", dap_view.toggle, "Toggle UI [DAP]")
set({ "n", "x" }, "<Leader>dw", "<Cmd>DapViewWatch<CR>", "Watch expression [DAP]")
set({ "n", "x" }, "<Leader>dh", "<Cmd>DapViewHover<CR>", "Hover value [DAP]")
