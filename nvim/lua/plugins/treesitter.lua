local parsers = {
  "bash", "c", "cpp", "css", "csv", "diff", "dockerfile", "editorconfig", "embedded_template",
  "git_rebase", "gitattributes", "gitcommit", "gitignore", "html", "ini",
  "javascript", "jsdoc", "json", "lua", "make", "markdown", "markdown_inline", "nginx", "perl",
  "python", "rbs", "regex", "rst", "ruby", "rust", "scss", "slim", "sql", "toml", "tsv",
  "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end

        if not vim.list_contains(treesitter.get_installed(), lang)
          and vim.list_contains(treesitter.get_available(), lang) then
          treesitter.install(lang)
          return
        end

        if pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
