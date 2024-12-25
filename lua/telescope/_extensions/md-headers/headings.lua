local headings = require("md-headers.headings")

local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local _create_displayer = function()
  return entry_display.create({
    separator = " ",
    items = {
      { width = 3 },
      { remaining = true },
    },
  })
end

local _create_entry_maker = function(displayer, heading)
  return {
    value = heading.line,
    display = function(entry)
      return displayer({
        { entry.depth, "TelescopeResultsNumber" },
        { entry.text },
      })
    end,
    ordinal = heading.text,
    depth = heading.depth,
    text = heading.text,
    line = heading.line,
  }
end

local _create_previewer = function(bufnr)
  return previewers.new_buffer_previewer({
    define_preview = function(self, entry)
      local lines = vim.api.nvim_buf_get_lines(bufnr, entry.value, entry.value + 10, false)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")
    end,
  })
end

local _attach_mappings = function(prompt_bufnr)
  actions.select_default:replace(function()
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.api.nvim_win_set_cursor(0, { selection.value + 1, 0 })
  end)
  return true
end

return function(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local headings_data = headings.get_headings(bufnr)

  if not next(headings_data) then
    vim.api.nvim_echo({ { "MDHeaders: no headings to display", "WarningMsg" } }, true, {})
    return
  end

  local displayer = _create_displayer()

  local entries = {}
  for _, heading in ipairs(headings_data) do
    table.insert(entries, _create_entry_maker(displayer, heading))
  end

  pickers
    .new(opts, {
      prompt_title = "Markdown Headers",
      finder = finders.new_table({
        results = entries,
        entry_maker = function(heading)
          return heading
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = _create_previewer(bufnr),
      attach_mappings = _attach_mappings,
    })
    :find()
end
