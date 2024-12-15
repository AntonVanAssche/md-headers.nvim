local M = {}
local cmds = {
  {
    name = "MDHeaders",
    closest = false,
    desc = "Generate a table of contents for a Markdown file.",
    options = { nargs = 0 },
    deprecated = "MarkdownHeaders",
  },
  {
    name = "MDHeadersCurrent",
    closest = true,
    desc = "Generate a table of contents for a Markdown file, using the closest heading.",
    options = { nargs = 0 },
    deprecated = "MarkdownHeadersClosest",
  },
}

local function command(cmd)
  vim.api.nvim_create_user_command(cmd.name, cmd.command, cmd.options)

  if cmd.deprecated then
    vim.api.nvim_create_user_command(cmd.deprecated, function()
      vim.api.nvim_echo({
        {
          "WARNING: this command has been marked as deprecated, use " .. cmd.name .. " instead.",
          "WarningMsg",
        },
      }, true, {})
      vim.cmd(cmd.name)
    end, cmd.options)
  end
end

-- Should only be called from plugin directory.
M.setup = function()
  for _, cmd in ipairs(cmds) do
    cmd.command =
      string.format("lua require('md-headers').markdown_headers(%s)", tostring(cmd.closest))

    command(cmd)
  end
end

return M
