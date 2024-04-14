local plugin = require("md-headers")

describe("setup", function()
  it("Works with no opts", function()
    plugin.setup()
  end)

  it("Works with empty opts", function()
    plugin.setup({})
  end)

  it("Works with opts", function()
    plugin.setup({
      width = 60,
      height = 10,
    })
  end)
end)
