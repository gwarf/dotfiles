-- Setup to write mails with vim

-- Enable spell checks using native spell checker
-- setlocal spell
-- No indentation when copying
-- set nocopyindent

-- Automatic line wrap
-- max line length
-- :help fo-table
-- set formatoptions=nawrjtcq
vim.opt.formatoptions = "tcqwan"
-- set comments+=n:\|  -- '|' is a quote char.
-- set comments+=n:% -- '%' as well.

-- vim-mail
-- https://github.com/dbeniamine/vim-mail/
-- Use khard as a contact provider
vim.g.VimMailContactsProvider = "khard"
-- Do not add custom keymaps
-- XXX some are nice to move inside the file
vim.g.VimMailDoNotMap = 1
vim.g.VimMailDoNotFold = 1
-- let g:VimMailSpellLangs=['en_gb', 'fr']
-- Complete emails address in every files
vim.opt.completefunc = "vimmail#contacts#CompleteAddr"
-- Choose where to put cursor
-- Remove quoted signature is killing mine due to flow automatic formatting
-- b: bottom after last message
-- o: add new line after cursor
-- i: insert mode
-- r: remove quoted signature from reply
vim.g.VimMailStartFlags = {
  reply = "boi"
}
-- let g:VimMailStartFlags={'reply' :"boir" }
-- let g:VimMailStartFlags={
-- \'blank': 'TAi',
-- \'nosubject': 'SAi',
-- \'default' : 'bOi'}
-- Use mu
-- let g:VimMailContactsCommands={'mu' :
--         \{ 'query' : "mu cfind",

--             \'sync': "mu index",
--             \'config': {
--                 \'default': {
--                     \'home': '$HOME/.mu',
--                     \'maildir': '$HOME/Mail',
--                 \}
--             \}
--         \}
--     \}
