vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set cursorline")
vim.cmd("set showfulltag")
vim.cmd("set shell=/bin/sh")
vim.cmd("set noshelltemp")
vim.cmd("set inccommand=nosplit")
vim.cmd("set undofile")
vim.cmd("set shiftround")
vim.cmd("set showmatch")
vim.cmd("set matchtime=2")
vim.cmd("set lazyredraw")
vim.cmd("set noshowmode")

vim.cmd("set wildmode=list:full")
vim.cmd("set wildignorecase")
vim.cmd("set splitbelow")
vim.cmd("set splitright")

vim.opt.colorcolumn = "120"

vim.opt.list = true
vim.opt.showbreak = "↪ "
vim.opt.listchars = {
  tab = '│\\ ',
  trail = '•',
  extends = '❯',
  precedes = '❮',
  space = '·'
}

vim.cmd("autocmd WinLeave * setlocal nocursorline")
vim.cmd("autocmd WinEnter * setlocal cursorline")

vim.g.mapleader = ","
vim.g.background = "light"

vim.opt.swapfile = false

vim.wo.number = true

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

vim.keymap.set("", "gh", "0", { noremap = true }) -- початок рядка
vim.keymap.set("", "gi", "^", { noremap = true }) -- перший непробільний символ
vim.keymap.set("", "gl", "g_", { noremap = true }) -- кінець рядка (ігноруючи \n)
vim.keymap.set("", "gj", "G", { noremap = true }) -- в кінець файлу
vim.keymap.set("", "gk", "gg", { noremap = true }) -- на початок файлу

-- В інсерт-режимі вставка з реєстру
vim.keymap.set("i", "<C-r>", "<C-r><C-p>", { noremap = true })

-- В інсерт-режимі вставка з системного буфера
vim.keymap.set("i", "<M-p>", "<C-r><C-p>+", { noremap = true })

-- У командному режимі вставка з системного буфера
vim.keymap.set("c", "<M-p>", "<C-r>+", { noremap = true })

-- Вставка з буфера обміну
vim.keymap.set("n", "p", '"+p', { noremap = true })
vim.keymap.set("v", "p", '"+p', { noremap = true })
vim.keymap.set("n", "<M-p>", "p", { noremap = true })
vim.keymap.set("v", "<M-p>", "p", { noremap = true })

vim.keymap.set("n", "P", '"+P', { noremap = true })
vim.keymap.set("v", "P", '"+P', { noremap = true })
vim.keymap.set("n", "<M-P>", "P", { noremap = true })
vim.keymap.set("v", "<M-P>", "P", { noremap = true })

-- Копіювання в буфер обміну
vim.keymap.set("n", "y", '"+y', { noremap = true })
vim.keymap.set("v", "y", '"+y', { noremap = true })
vim.keymap.set("n", "<M-y>", "y", { noremap = true })
vim.keymap.set("v", "<M-y>", "y", { noremap = true })

vim.keymap.set("n", "Y", '"+y$', { noremap = true })
vim.keymap.set("n", "<M-Y>", "y$", { noremap = true })
vim.keymap.set("v", "<M-Y>", "y$", { noremap = true })

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
vim.keymap.set("n", "/", "/\\v", { noremap = true })
vim.keymap.set("v", "/", "/\\v", { noremap = true })
-- Пошук назад з very magic у нормальному і візуальному режимах
vim.keymap.set("n", "?", "?\\v", { noremap = true })
vim.keymap.set("v", "?", "?\\v", { noremap = true })

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

-- Перезавантаження конфігурації Vim
vim.keymap.set("n", "<leader>R", ":so $MYVIMRC<CR>", opts)

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
vim.keymap.set("n", "K", "<Plug>(IndentWiseBlockScopeBoundaryBegin)", { silent = true })
vim.keymap.set("n", "J", "<Plug>(IndentWiseBlockScopeBoundaryEnd)", { silent = true })

-- Звичайне J на <M-i> (Alt+i)
vim.keymap.set("n", "<M-i>", "J", opts)
