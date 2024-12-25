local M = {}
local cmds = {
  {
    name = "MDHeaders",
    desc = "Generate a table of contents for a Markdown file.",
    func = function()
      require("md-headers").markdown_headers(false)
    end,
    options = { nargs = 0 },
    deprecated = "MarkdownHeaders",
  },
  {
    name = "MDHeadersCurrent",
    desc = "Generate a table of contents for a Markdown file, using the closest heading.",
    func = function()
      require("md-headers").markdown_headers(true)
    end,
    options = { nargs = 0 },
    deprecated = "MarkdownHeadersClosest",
  },
}

local function command(cmd)
  vim.api.nvim_create_user_command(cmd.name, cmd.func, cmd.options)

  if cmd.deprecated then
    vim.api.nvim_create_user_command(cmd.deprecated, function()
      vim.api.nvim_echo({
        {
          "WARNING: this command has been marked as deprecated, use " .. cmd.name .. " instead.",
          "WarningMsg",
        },
      }, true, {})
      cmd.func()
    end, cmd.options)
  end
end

-- Should only be called from plugin directory.
M.setup = function()
  for _, cmd in ipairs(cmds) do
    command(cmd)
  end
end

return M
