--[[
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Core
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
]]
-- Settings
local settings = {
  cache_dir = vim.fn.expand("~/.config/nvim/.cache"),
  default_indent = 2,
  max_column = 120,
}

-- Helper functions
local function get_cache_dir(suffix)
  return vim.fn.resolve(settings.cache_dir .. "/" .. suffix)
end

local function ensure_exists(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Create necessary directories
ensure_exists(settings.cache_dir)
ensure_exists(get_cache_dir("swap"))

-- Swap files
vim.opt.directory = get_cache_dir("swap")
vim.opt.swapfile = false

-- Base configuration
vim.opt.showfulltag = true
vim.opt.shell = "/bin/sh"
vim.opt.shelltemp = false
vim.opt.inccommand = "nosplit"
vim.opt.undofile = true

-- Whitespace
vim.opt.expandtab = true
vim.opt.tabstop = settings.default_indent
vim.opt.softtabstop = settings.default_indent
vim.opt.shiftwidth = settings.default_indent
vim.opt.list = true
vim.opt.listchars = { tab = "│ ", trail = "•", extends = "❯", precedes = "❮", space = "·" }
vim.opt.shiftround = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "

-- Command-line completion
vim.opt.wildmode = { "list", "full" }
vim.opt.wildignorecase = true

-- Window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.grepprg = "ag --nogroup --column --smart-case --nocolor --follow"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- UI configuration
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.number = true
vim.opt.lazyredraw = true
vim.opt.showmode = false
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99
vim.opt.completeopt:remove("preview")

vim.opt.cursorline = true
vim.opt.colorcolumn = tostring(settings.max_column)

-- Autocommands for cursorline
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

--[[
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
]]
vim.keymap.set("n", "<M-8>", "#", { noremap = true })
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true })

vim.keymap.set("n", "<left>", ":bprev<CR>", { noremap = true })
vim.keymap.set("n", "<right>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<up>", ":tabnext<CR>", { noremap = true })
vim.keymap.set("n", "<down>", ":tabprev<CR>", { noremap = true })

vim.keymap.set("n", "<M-h>", "<C-w>3<", { noremap = true })
vim.keymap.set("n", "<M-l>", "<C-w>3>", { noremap = true })
vim.keymap.set("n", "<M-j>", "<C-w>3-", { noremap = true })
vim.keymap.set("n", "<M-k>", "<C-w>3+", { noremap = true })

vim.keymap.set("c", "<M-h>", "<Left>", { noremap = true })
vim.keymap.set("c", "<M-l>", "<Right>", { noremap = true })
vim.keymap.set("c", "<M-j>", "<Down>", { noremap = true })
vim.keymap.set("c", "<M-k>", "<Up>", { noremap = true })

vim.keymap.set("n", "]w", ":tabnext<CR>", { noremap = true })
vim.keymap.set("n", "[w", ":tabprev<CR>", { noremap = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

vim.keymap.set("", "gh", "0", { noremap = true })  -- початок рядка
vim.keymap.set("", "gi", "^", { noremap = true })  -- перший непробільний символ
vim.keymap.set("", "gl", "g_", { noremap = true }) -- кінець рядка (ігноруючи \n)
vim.keymap.set("", "gj", "G", { noremap = true })  -- в кінець файлу
vim.keymap.set("", "gk", "gg", { noremap = true }) -- на початок файлу

-- В інсерт-режимі вставка з реєстру
vim.keymap.set("i", "<C-r>", "<C-r><C-p>", { noremap = true })

-- В інсерт-режимі вставка з системного буфера
vim.keymap.set("i", "<M-p>", "<C-r><C-p>+", { noremap = true })

-- У командному режимі вставка з системного буфера
vim.keymap.set("c", "<M-p>", "<C-r>+", { noremap = true })

-- Вставка з буфера обміну
vim.keymap.set({"n", "v"}, "p", '"+p', { noremap = true })
vim.keymap.set({"n", "v"}, "<M-p>", "p", { noremap = true })

vim.keymap.set({"n", "v"}, "P", '"+P', { noremap = true })
vim.keymap.set({"n", "v"}, "<M-P>", "P", { noremap = true })

-- Копіювання в буфер обміну
vim.keymap.set({"n", "v"}, "y", '"+y', { noremap = true })
vim.keymap.set({"n", "v"}, "<M-y>", "y", { noremap = true })

vim.keymap.set("n", "Y", '"+y$', { noremap = true })
vim.keymap.set({"n", "v"}, "<M-Y>", "y$", { noremap = true })

-- Вирізання в буфер обміну
vim.keymap.set("n", ",d", '"+d', { noremap = true })
vim.keymap.set("v", ",d", '"+d', { noremap = true })
vim.keymap.set("n", ",D", '"+D', { noremap = true })
vim.keymap.set("v", ",D", '"+D', { noremap = true })

-- <C-u> в інсерт-режимі для видалення до початку рядка без зміни undo
vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", { noremap = true })
-- <C-d> переналаштовано на <Del> в інсерт-режимі
vim.keymap.set("i", "<C-d>", "<Del>", { noremap = true })

-- Пошук вперед з very magic у нормальному і візуальному режимах
vim.keymap.set({"n", "v"}, "/", "/\\v", { noremap = true })
-- Пошук назад з very magic у нормальному і візуальному режимах
vim.keymap.set({"n", "v"}, "?", "?\\v", { noremap = true })

-- Глобальна заміна в усьому файлі в нормальному режимі
vim.keymap.set("n", "dm", ":%s:::g<left><left><left>", { noremap = true })
-- Заміна для виділеного тексту у візуальному режимі
vim.keymap.set("v", "dm", ":s:::g<left><left><left>", { noremap = true })

-- Перехід до командного рядка з режимом вставки після q:
vim.keymap.set("n", "q:", "q:i", { noremap = true })
-- Перехід до пошуку вперед з режимом вставки після q/
vim.keymap.set("n", "q/", "q/i", { noremap = true })
-- Перехід до пошуку назад з режимом вставки після q?
vim.keymap.set("n", "q?", "q?i", { noremap = true })

-- Розгортання блоку на рівень вище з відображенням рівня складання
vim.keymap.set("n", "zr", "zr:echo &foldlevel<CR>", { noremap = true })
-- Складання блоку на рівень вище з відображенням рівня складання
vim.keymap.set("n", "zm", "zm:echo &foldlevel<CR>", { noremap = true })
-- Розгортання всіх блоків з відображенням рівня складання
vim.keymap.set("n", "zR", "zR:echo &foldlevel<CR>", { noremap = true })
-- Згортання всіх блоків з відображенням рівня складання
vim.keymap.set("n", "zM", "zM:echo &foldlevel<CR>", { noremap = true })

-- Після переходу до попереднього місця, переміщаємо курсор в центр екрану
vim.keymap.set("n", "<C-o>", "<C-o>zz", { noremap = true, silent = true })
-- Після переходу до наступного місця, переміщаємо курсор в центр екрану
vim.keymap.set("n", "<C-i>", "<C-i>zz", { noremap = true, silent = true })

-- Зсув вліво, збереження візуального режиму
vim.keymap.set("v", "<", "<gv", { noremap = true })
-- Зсув вправо, збереження візуального режиму
vim.keymap.set("v", ">", ">gv", { noremap = true })

vim.keymap.set("n", "gp", function()
  return "`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, { noremap = true, expr = true })

-- Відкриває вертикальний спліт і переміщає курсор у нове вікно
vim.keymap.set("n", "<leader>v", "<C-w>v<C-w>l", { noremap = true })
-- Відкриває горизонтальний спліт
vim.keymap.set("n", "<leader>s", "<C-w>s", { noremap = true })
-- Виконує вертикальне сортування буферів
vim.keymap.set("n", "<leader>vsa", ":vert sba<CR>", { noremap = true })

-- Створення нової вкладки
vim.keymap.set("n", "<leader>tn", ":tab spl<CR>", { noremap = true })
-- Закриття поточної вкладки
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true })

-- Перемикання відображення невидимих символів
vim.keymap.set("n", "<leader>l", ":set list! list?<CR>", { noremap = true })
-- Очищення підсвічування пошуку
vim.keymap.set("n", "<BS>", ":noh<CR>", { noremap = true })
-- Виділення від поточної позиції до кінця рядка
vim.keymap.set("n", "<M-v>", "vg_", { noremap = true })
-- <C-s> переназначено на <C-a>
vim.keymap.set("n", "<C-s>", "<C-a>", { noremap = true })
-- Перезавантаження конфігурації Vim
vim.keymap.set("n", "<leader>R", ":so $MYVIMRC<CR>", { noremap = true })

-- Базові опції
local opts = { noremap = true, silent = true }

-- <C-s> переназначено на <C-a>
vim.keymap.set("n", "<C-s>", "<C-a>", opts)

-- Terminal mode
vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>", opts)
vim.keymap.set("t", "<Left>", "<C-\\><C-n>:bprev<CR>", opts)
vim.keymap.set("t", "<Right>", "<C-\\><C-n>:bnext<CR>", opts)
vim.keymap.set("t", "<Up>", "<C-\\><C-n>:tabnext<CR>", opts)
vim.keymap.set("t", "<Down>", "<C-\\><C-n>:tabprev<CR>", opts)

-- Переміщення рядків
vim.keymap.set("n", "<C-S-Down>", ":m+<CR>==", opts)
vim.keymap.set("n", "<C-S-Up>", ":m-2<CR>==", opts)
vim.keymap.set("i", "<C-S-Down>", "<Esc>:m+<CR>==gi", opts)
vim.keymap.set("i", "<C-S-Up>", "<Esc>:m-2<CR>==gi", opts)
vim.keymap.set("v", "<C-S-Down>", ":m'>+<CR>gv=gv", opts)
vim.keymap.set("v", "<C-S-Up>", ":m-2<CR>gv=gv", opts)

-- IndentWise (без noremap, бо це <Plug>)
vim.keymap.set({"n", "v"}, "K", "<Plug>(IndentWiseBlockScopeBoundaryBegin)", { silent = true })
vim.keymap.set({"n", "v"}, "J", "<Plug>(IndentWiseBlockScopeBoundaryEnd)", { silent = true })

-- Звичайне J на <M-i> (Alt+i)
vim.keymap.set("n", "<M-i>", "J", opts)

-- Delete to beginning of line (already default, but explicit)
vim.keymap.set("i", "<C-u>", "<C-u>")
-- Delete to end of line
vim.keymap.set("i", "<C-k>", "<C-o>D")
-- Delete previous word (already default, but explicit)
vim.keymap.set("i", "<C-w>", "<C-w>")

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, { mark[1], mark[2] })
      vim.cmd("normal! zvzz")
    end
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

vim.opt.autowriteall = true


-- Function to strip trailing whitespace before saving
local function strip_trailing_whitespaces()
  local curr_line = vim.fn.line(".")
  local curr_col = vim.fn.col(".")

  -- Strip trailing whitespace from the entire file
  vim.cmd("%s/\\s\\+$//e")

  -- Restore cursor position
  vim.fn.cursor(curr_line, curr_col)
end

-- Set up the autocommand to run before saving any file
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = strip_trailing_whitespaces,
})
