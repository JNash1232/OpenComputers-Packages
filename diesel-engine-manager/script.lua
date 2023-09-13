local component = require("component")
local os = require("os")
local term = require("term")

local settings = dofile("/usr/bin/diesel-engine-manager/settings.cfg")

local function rs(address, val)
    for address in pairs(settings.redstone_addresses) do
        local rs = component.proxy(component.get(address))
        rs.setOutput({val, val, val, val, val, val})
    end
end

while true do
    if (settings.debug == true) then
        term.clear()
    end

    for index in pairs(settings.generators) do
        os.sleep(1)
        local battery_buffer = component.proxy(component.get(settings.generators[index].battery_buffer_address))
        local redstone_address = component.proxy(component.get(settings.generators[index].redstone_address))
        local low_capacity = settings.generators[index].low_capacity
        local high_capacity = settings.generators[index].high_capacity
        local battery_percent = battery_buffer.getEnergyStored() / battery_buffer.getEnergyCapacity()
        local enabled = settings.generators[index].enabled

        if (battery_percent > high_capacity) then
            rs(redstone_address, 0)
        elseif (battery_percent < low_capacity and enabled) then
            rs(redstone_address, 15)
        end
    end
    os.sleep(1)
end
