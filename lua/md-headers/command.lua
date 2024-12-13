local M = {}
local cmds = {
  {
    name = "MarkdownHeaders",
    closest = false,
    desc = "Generate a table of contents for a Markdown file.",
    options = { nargs = 0 },
  },
  {
    name = "MarkdownHeadersClosest",
    closest = true,
    desc = "Generate a table of contents for a Markdown file, using the closest heading.",
    options = { nargs = 0 },
  },
}

local function command(cmd)
  vim.api.nvim_create_user_command(cmd.name, cmd.command, cmd.options)
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
