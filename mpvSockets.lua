-- mpvSockets, one socket per instance, removes socket on exit

local utils = require 'mp.utils'

local function get_temp_path()
    local example_temp_file_path = os.tmpname()

    -- remove generated temp file
    pcall(os.remove, example_temp_file_path)

    return utils.split_path(example_temp_file_path)
end

tempDir = get_temp_path()

function join_paths(...)
    local arg={...}
    local path = ""
    for i,v in ipairs(arg) do
        path = utils.join_path(path, tostring(v))
    end
    return path;
end

ppid = utils.getpid()
os.execute("mkdir -- " .. join_paths(tempDir, "mpvSockets") .. " 2>/dev/null")
mp.set_property("options/input-ipc-server", join_paths(tempDir, "mpvSockets", ppid))

function shutdown_handler()
        os.remove(join_paths(tempDir, "mpvSockets", ppid))
        os.remove(join_paths(tempDir, "mpvSockets"))
end
mp.register_event("shutdown", shutdown_handler)
