local map = vim.keymap.set
vim.g.mapleader = " "

-- Save current file
map("n", "<leader>w", ":w<cr>", { desc = "Save file", remap = true })

-- move line
map("v", "J", ":m '>+2<CR>gv=gv")
map("v", "K", ":m '<-1<CR>gv=gv")

-- ESC pressing jk
map("i", "jk", "<ESC>", { desc = "jk to esc", noremap = true })


-- Increment/decrement
map("n", "+", "<C-a>", { desc = "Increment numbers", noremap = true })
map("n", "-", "<C-x>", { desc = "Decrement numbers", noremap = true })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all", noremap = true })

-- Indenting
map("v", "<", "<gv", { desc = "Indenting", silent = true, noremap = true })
map("v", ">", ">gv", { desc = "Indenting", silent = true, noremap = true })

-- Tabs
map("n", "<leader>t", ":tabedit<Return>", { desc = "Adds Tab"})
map("n", "<leader>b", ":bd<Return>", { desc= "Removes Tab" })
map("n", "<leader>B", ":bd!<Return>", { desc= "Force Removes Tab" })

-- Split window
map("n", "<leader>sh", ":split<Return><C-w>w", { desc = "splits horizontal", noremap = true })
map("n", "<leader>sv", ":vsplit<Return><C-w>w", { desc = "Split vertical", noremap = true })

-- Navigate vim panes better
map("n", "<C-Up>", "<C-w>k", { desc = "Navigate up" })
map("n", "<C-Down>", "<C-w>j", { desc = "Navigate down" })
map("n", "<C-Left>", "<C-w>h", { desc = "Navigate left" })
map("n", "<C-Right>", "<C-w>l", { desc = "Navigate right" })

-- Change 3 split windows from vertical to horizontal or vice versa
map("n", "<leader>th", "<C-w>t<C-w>H", { desc = "Change window splits to horizontal", noremap = true})	
map("n", "<leader>tk", "<C-w>t<C-w>K", { desc = "Change window splits to vertical", noremap = true})


-- Jump to End of Line (Replaces Jump to End of Word)
map("n", "e", "$", {desc = "Jump to End of Line"})

-- Redo last Action (Replaces restore last changed Line)
map("n", "U", "<C-r>", {desc = "Undo Last Action"})

-- Resize window
map("n", "<C-S-Up>", ":resize +2<CR>")
map("n", "<C-S-Down>", ":resize -2<CR>")
map("n", "<C-S-Left>", ":vertical resize +2<CR>")
map("n", "<C-S-Right>", ":vertical resize -2<CR>")

--Close window
map("n", "<leader>q", "<c-w>c", { desc= "Closes Window"})

-- Barbar
map("n", "<Tab>", ":BufferNext<CR>", { desc = "Move to next tab", noremap = true })
map("n", "<S-Tab>", ":BufferPrevious<CR>", { desc = "Move to previous tab", noremap = true })
map("n", "<leader>x", ":BufferClose<CR>", { desc = "Buffer close", noremap = true })
map("n", "<A-p>", ":BufferPin<CR>", { desc = "Pin buffer", noremap = true })
map("n", "<leader><Left>", ":BufferPrevious<CR>", { desc = "Move to previous Buffer", noremap = true })
map("n", "<leader><Right>", ":BufferNext<CR>", { desc = "Move to next Buffer", noremap = true})

-- Comments
map({"n", "v"}, "<leader>co", ":CommentToggle<cr>", { desc = "CommentToggle", noremap = true })

map("n", "<leader>ccc", ":let g:copilot_enabled = 0<CR>", {desc = "Disable Copilot", noremap = true})




-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find_files", noremap = true })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope live_grep", noremap = true })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Telescope oldfiles", noremap = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Telescope buffers", noremap = true })

-- Spectre
map('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre", noremap = true })
map('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Spectre Search current word", noremap = true })
map('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word", noremap = true })
map('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file", noremap = true})
