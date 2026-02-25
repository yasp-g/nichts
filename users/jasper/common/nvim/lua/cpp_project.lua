-- ~/.config/nvim/lua/cpp_project.lua

local function directory_to_filename(dir_name)
    return dir_name:gsub("-", "_")
end

vim.api.nvim_create_user_command('CppProject', function()
    local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local project_name = directory_to_filename(project_dir)
    
    local cpp_file = project_name .. '.cpp'
    local h_file = project_name .. '.h'
    local test_file = project_name .. '_test.cpp'

    local function file_exists(file)
        return vim.fn.filereadable(file) == 1
    end

    if not file_exists(cpp_file) or not file_exists(h_file) or not file_exists(test_file) then
        print("Could not find all required files for project: " .. project_name)
        return
    end
    
    -- Open the main .cpp file
    vim.cmd('edit ' .. cpp_file)
    
    -- Vertical split for the header file
    vim.cmd('vsplit ' .. h_file)
    
    -- Horizontal split below the header file for the test file
    vim.cmd('split ' .. test_file)
    
    -- Move cursor back to the main .cpp file on the left
    vim.cmd('wincmd h')
end, {})

-- Optional: Set up a key mapping for quick access
vim.keymap.set('n', '<leader>cpp', ':CppProject<CR>', { noremap = true, silent = true })
