-- mpvSockets, one socket per instance, removes socket on exit

local utils = require 'mp.utils'

local function get_temp_path()
    local example_temp_file_path = os.tmpname()

    -- remove generated temp file
    pcall(os.remove, example_temp_file_path)

    return utils.split_path(example_temp_file_path)
end

temp_dir = get_temp_path()

function join_paths(...)
    local arg={...}
    local path = ""
    for i,v in ipairs(arg) do
        path = utils.join_path(path, tostring(v))
    end
    return path;
end

function mkdir(...)
    return mp.command_native({
        name = "subprocess",
        capture_stdout = true,
        capture_stderr = true,
        playback_only = false,
        args = {"mkdir", "--", ...},
    })
end

ppid = utils.getpid()
mkdir(join_paths(temp_dir, "mpvSockets"))
mp.set_property("options/input-ipc-server", join_paths(temp_dir, "mpvSockets", ppid))

function shutdown_handler()
        os.remove(join_paths(temp_dir, "mpvSockets", ppid))
        os.remove(join_paths(temp_dir, "mpvSockets"))
end
mp.register_event("shutdown", shutdown_handler)
