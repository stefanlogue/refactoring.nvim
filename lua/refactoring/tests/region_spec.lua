local Region = require("refactoring.region")
local eq = assert.are.same

describe("Region", function()

    it("select text : line", function()
        vim.cmd(":new")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "foo",
            "if (true) {",
            "    bar",
            "}",
        })
        vim.cmd(":norm! jVVV")
        local region = Region:from_current_selection()
        eq(region:get_text(), {"if (true) {"})
    end)

    it("select text : partial-line", function()
        vim.cmd(":new")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "foo",
            "if (true) {",
            "    bar",
            "}",
        })

        -- TODO: Why is first selection just not present...
        vim.cmd(":norm! jwvwwvbbvww")
        eq("v", vim.fn.mode())
        local region = Region:from_current_selection()
        eq({"(true)"}, region:get_text())
    end)

    it("select text : multi-partial-line", function()
        vim.cmd(":new")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "foo",
            "if (true) {",
            "    bar",
            "}",
        })

        -- TODO: Why is first selection just not present...
        vim.cmd(":1")
        vim.cmd(":execute \"norm! jwvje\\<Esc>\"")
        eq("n", vim.fn.mode())
        eq(3, vim.fn.line('.'))
        local region = Region:from_current_selection()
        eq({"(true) {", "    bar"}, region:get_text())
    end)

end)

