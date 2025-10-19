local M = {}
local cmds = {
  {
    name = "MDHeaders",
    desc = "Generate a table of contents for a Markdown file.",
    func = function()
      require("md-headers").markdown_headers(false)
    end,
    options = { nargs = 0 },
  },
  {
    name = "MDHeadersCurrent",
    desc = "Generate a table of contents for a Markdown file, using the closest heading.",
    func = function()
      require("md-headers").markdown_headers(true)
    end,
    options = { nargs = 0 },
  },
  {
    name = "MDHeadersQuickfix",
    desc = "Generate a quickfix list of headings for a Markdown file.",
    func = function()
      require("md-headers").quickfix()
    end,
    options = { nargs = 0 },
  },
  {
    name = "MDHeadersTelescope",
    desc = "Open a Telescope window with headings for a Markdown file.",
    func = function()
      vim.cmd("Telescope md-headers headings")
    end,
    options = { nargs = 0 },
  },
}

local function command(cmd)
  vim.api.nvim_create_user_command(cmd.name, cmd.func, cmd.options)
end

-- Should only be called from plugin directory.
M.setup = function()
  for _, cmd in ipairs(cmds) do
    command(cmd)
  end
end

return M
