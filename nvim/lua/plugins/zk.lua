return {
    "zk-org/zk-nvim",
    config = function()
        local zk = require("zk")
        local commands = require("zk.commands")

        -- Setup LSP + picker
        zk.setup({
            picker = "snacks_picker",
            lsp = {
                config = {
                    cmd = { "zk", "lsp" },
                    name = "zk",
                },
                auto_attach = { enabled = true, filetypes = { "markdown" } },
            },
        })

        -- Helpers
        local function new_note(dir, extra)
            return function()
                local opts = vim.tbl_extend("force", { dir = dir, noInput = true }, extra or {})
                zk.new(opts)
            end
        end

        local function to_snake_case(str)
            return str:lower():gsub("[^%w%s]", ""):gsub("%s+", "_")
        end

        local function titled_note(dir, prompt, extra)
            return function()
                vim.ui.input({ prompt = (prompt or "Title") .. ": " }, function(title)
                    if title and title ~= "" then
                        local opts = vim.tbl_extend("force", {
                            dir = dir,
                            title = title,
                            noInput = true,
                            extra = {
                                title_snake = to_snake_case(title),
                            },
                        }, extra or {})
                        require("zk").new(opts)
                    end
                end)
            end
        end

        local function list_notes(subdir, view_title)
            return function()
                local path = vim.fn.expand("$ZK_NOTEBOOK_DIR/" .. subdir)
                if vim.fn.isdirectory(path) == 0 then
                    -- raise an error if the directory doesn't exist
                    vim.notify("Directory " .. path .. " does not exist", vim.log.levels.ERROR)
                    return
                end
                zk.edit({
                    hrefs = { subdir },
                    sort = { "created" },
                }, { title = view_title })
            end
        end

        -- 📌 Create note commands
        commands.add("ZkDaily", new_note("daily"))
        commands.add("ZkStandup", new_note("su"))
        commands.add("ZkMeeting", titled_note("meetings", "Meeting title"))
        commands.add("ZkIdea", titled_note("ideas", "Idea title"))
        commands.add("ZkIdeaYT", titled_note("ideas", "YouTube idea title", { group = "youtube" }))

        -- 📚 View note commands
        commands.add("ZkJournal", list_notes("daily", "Daily"))
        commands.add("ZkIdeas", list_notes("ideas", "Ideas"))
        commands.add("ZkStandups", list_notes("su", "Standups"))
        commands.add("ZkMeetings", list_notes("meetings", "Meetings"))

        -- 🔑 Keybindings
        local map = vim.keymap.set

        -- Creation
        map("n", "<leader>zd", "<cmd>ZkDaily<CR>", { desc = "Daily note" })
        map("n", "<leader>zi", "<cmd>ZkIdea<CR>", { desc = "New idea note" })
        map("n", "<leader>zs", "<cmd>ZkStandup<CR>", { desc = "New standup note" })
        map("n", "<leader>zm", "<cmd>ZkMeeting<CR>", { desc = "New meeting note" })

        -- Views
        map("n", "<leader>zvd", "<cmd>ZkJournal<CR>", { desc = "View daily" })
        map("n", "<leader>zvi", "<cmd>ZkIdeas<CR>", { desc = "View ideas" })
        map("n", "<leader>zvs", "<cmd>ZkStandups<CR>", { desc = "View standups" })
        map("n", "<leader>zvm", "<cmd>ZkMeetings<CR>", { desc = "View meetings" })

        -- Search
        map("n", "<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "All notes" })
        map("n", "<leader>zt", "<cmd>ZkTags<CR>", { desc = "Search tags" })

        -- Linking
        map("n", "<leader>zB", "<cmd>ZkBacklinks<CR>", { desc = "Backlinks" })
        map("n", "<leader>zL", "<cmd>ZkLinks<CR>", { desc = "Links" })
        map("v", "<leader>zl", ":'<,'>ZkInsertLinkAtSelection<CR>", { desc = "Link at selection" })

        -- Utilities
        map("n", "<leader>zcd", "<cmd>ZkCd<CR>", { desc = "CD to root" })
        map("n", "<leader>zx", "<cmd>ZkIndex<CR>", { desc = "Index notebook" })
    end,
}
