return {
    "nvim-neo-tree/neo-tree.nvim",
    keys = { -- only load the plugin on these keymaps
        { "<leader>b",      ":Neotree toggle <CR>" },
        { "<leader>nb", ":Neotree buffers reveal float<CR>" },
    },
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = false,
            filesystem = {
                filtered_items = {
                    visible = true,
                    show_hidden_count = true,
                    hide_dotfiles = false,
					hide_gitignored = false,
                    hide_by_name = {
						-- '.git',
                        -- '.DS_Store',
                        -- 'thumbs.db',
                    },
                    never_show = {},
                },
            },
			popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            source_selector = {
                winbar = false,
                statusline = false,
            },
        })
    end,
}
