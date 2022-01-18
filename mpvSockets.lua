-- mpvSockets, one socket per instance, removes socket on exit

local utils = require 'mp.utils'

local function get_temp_path()
    local example_temp_file_path = os.tmpname()

    -- remove generated temp file
    os.remove(example_temp_file_path)

    return utils.split_path(example_temp_file_path)
end

local function mkdir(...)
    return mp.command_native({
        name = "subprocess",
        capture_stdout = true,
        capture_stderr = true,
        playback_only = false,
        args = {"mkdir", "--", ...},
    })
end

local ppid = utils.getpid()
local temp_dir = get_temp_path()

local socket_dir = utils.join_path(temp_dir, "mpvSockets")
local socket_path = utils.join_path(socket_dir, ppid)

mkdir(socket_dir)
mp.set_property("options/input-ipc-server", socket_path)

mp.register_event("shutdown", function() os.remove(socket_dir); os.remove(socket_path) end)
