local get_test_file_name = function(bufnr)
	local file_name = vim.api.nvim_buf_get_name(bufnr)
	local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")

	if file_type == "go" then
		local is_test_file = file_name:match("_test.go$") ~= nil
		if is_test_file then
			return file_name
		end
		local full_path_without_extension = vim.fn.fnamemodify(file_name, ":r")
		return full_path_without_extension .. "_test.go"
	end
end

local get_source_file_name = function(bufnr)
	local file_name = vim.api.nvim_buf_get_name(bufnr)
	local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")

	if file_type == "go" then
		local is_test_file = file_name:match("_test.go$") ~= nil
		if not is_test_file then
			return file_name
		end
		local full_path_without_extension = vim.fn.fnamemodify(file_name, ":r")
		local fullpath_without_test = full_path_without_extension:gsub("_test$", "")
		return fullpath_without_test .. ".go"
	end
end

local open_file_with_split = function(file_name, split_direction)
	local commands = {
		h = ":split",
		horizontal = ":split",
		v = ":vsplit",
		vertical = ":vsplit",
		default = ":edit",
	}

	local command = commands[split_direction] or commands.default
	vim.cmd(command .. file_name)
end

local toggle_file = function(split_direction)
	-- get current buffer
	local bufnr = vim.api.nvim_get_current_buf()
	local current_filename = vim.api.nvim_buf_get_name(0)

	local get_filename = current_filename:match("_test.go$") ~= nil and get_source_file_name or get_test_file_name
  local file_name = get_filename(bufnr)

	if file_name and vim.fn.filereadable(file_name) == 1 then
		print("open: " .. file_name)
	else
		print("create: " .. file_name)
	end

	open_file_with_split(file_name, split_direction)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"python", "lua", "rust"},
  callback = function()
    local settings = {
      python = { indent = 4, expandtab = true },
      lua = { indent = 2, expandtab = true },
      rust = { indent = 4, expandtab = true }
    }
    local ft = vim.bo.filetype
    if settings[ft] then
      vim.bo.shiftwidth = settings[ft].indent
      vim.bo.expandtab = settings[ft].expandtab
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', { pattern = 'go', command = 'setlocal sw=4 sts=4 ts=4 noexpandtab' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = {"go", "gomod"},
  callback = function()
    vim.keymap.set("n", ",A", function()
      toggle_file("")
    end, { noremap = true, silent = true, desc = "open test file" })

    vim.keymap.set("n", ",vA", function()
      toggle_file("vertical")
    end, { noremap = true, silent = true, desc = "open test file vertically" })

    vim.keymap.set("n", ",hA", function()
      toggle_file("horizontal")
    end, { noremap = true, silent = true, desc = "toggle test file horizontally" })

    vim.bo.commentstring = "// %s"
  end,
})
