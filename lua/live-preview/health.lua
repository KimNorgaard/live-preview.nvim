local M = {}

local utils = require("live-preview.utils")

local min_nvim_version = "0.10.0"
local nvim_ver_table = vim.version()
local nvim_ver = string.format("%d.%d.%d", nvim_ver_table.major, nvim_ver_table.minor, nvim_ver_table.patch)

local function check_command_exists(cmd)
    return vim.fn.executable(cmd) == 1
end


function M.is_compatible(ver, min_ver)
    local requirement = vim.version.range(">=" .. min_ver)
    return requirement:has(ver)
end

M.check = function()
    vim.health.start("Live Preview Health Check")
    if not M.is_compatible(nvim_ver, min_nvim_version) then
        vim.health.warn(
            "Live Preview requires Neovim version " .. min_nvim_version .. " or higher, but you are using " .. nvim_ver
        )
    else
        vim.health.ok("Neovim version is compatible with Live Preview")
    end

    vim.health.info("\n")
    vim.health.info(
        "For Live Preview to open default browser, at least one of these commands must be executable. If you have specified a custom browser in your configuration, you can ignore this message.")
    local open_cmds = { "xdg-open", "open", "start", "rundll32", "wslview" }
    for _, cmd in ipairs(open_cmds) do
        if check_command_exists(cmd) then
            vim.health.ok(cmd)
        else
            vim.health.warn(cmd .. " not available")
        end
    end
end

return M