-- Maded by Cosmo for github.com/c0sui/ease_lua

local imgui = require "mimgui"
local ease = require "ease"
local ffi = require "ffi"

local list = imgui.new["const char*"][31]({
	"linear",
	"inSine", "outSine", "inOutSine",
	"inQuad", "outQuad", "inOutQuad",
	"inCubic", "outCubic", "inOutCubic",
	"inQuart", "outQuart", "inOutQuart",
	"inQuint", "outQuint", "inOutQuint",
	"inExpo", "outExpo", "inOutExpo",
	"inCirc", "outCirc", "inOutCirc",
	"inBack", "outBack", "inOutBack",
	"inElastic", "outElastic", "inOutElastic",
	"inBounce", "outBounce", "inOutBounce"
})
local select = imgui.new.int(0)
local duration = imgui.new.float(3.00)
local value = 1.00
local process = nil

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	imgui.GetStyle().AntiAliasedLines = false
end)

imgui.OnFrame(
    function() return true end,
    function(self)
    	local sX, sY = getScreenResolution()
    	local wSize = imgui.ImVec2(500, 250)

    	imgui.SetNextWindowSize(wSize, imgui.Cond.Always)
		imgui.SetNextWindowPos(imgui.ImVec2(sX / 2, sY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		
		imgui.Begin("Ease Demo", nil, imgui.WindowFlags.NoDecoration)
			imgui.Columns(2, "Dashboard-Begin", true)
			imgui.SetColumnWidth(0, 100)
			imgui.BeginGroup()
				if imgui.Button("from 0 to 1", imgui.ImVec2(-1, 0)) then
					local method = ffi.string(list[select[0]])
					if process and not process.dead then process:terminate() end
					process = ease(0, 1, os.clock(), duration[0], method, function(f)
						value = f
					end)
				end
				if imgui.Button("from 1 to 0", imgui.ImVec2(-1, 0)) then
					local method = ffi.string(list[select[0]])
					if process and not process.dead then process:terminate() end
					process = ease(1, 0, os.clock(), duration[0], method, function(f)
						value = f
					end)
				end
			imgui.EndGroup()
			imgui.NextColumn()
			imgui.BeginGroup()
				imgui.Combo("Easing Type", select, list, 31)
				imgui.InputFloat("Duration (sec)", duration, 0.1, 1, "%0.2f")
			imgui.EndGroup()
			imgui.Columns(1, "Dashboard-End", true)

			imgui.Spacing()
			imgui.Separator()
			imgui.NewLine()

			local text_value = string.format("Current value: %0.2f", value)
			local ts = imgui.CalcTextSize(text_value)
			imgui.SetCursorPosX((wSize.x - ts.x) / 2)
			imgui.Text(text_value)
			imgui.NewLine()

			local DL = imgui.GetWindowDrawList()
			local p = imgui.GetCursorScreenPos()
			local max_w = imgui.GetContentRegionAvail().x
			local c = imgui.ImVec2(p.x + max_w / 2, p.y + 70)

			-- Background Line
			DL:AddLine(
				imgui.ImVec2(p.x, p.y),
				imgui.ImVec2(p.x + max_w, p.y),
				0x20FFFFFF, 10
			)

			-- Process Line
			DL:AddLine(
				imgui.ImVec2(p.x + 50, p.y),
				imgui.ImVec2(p.x + 50 + (max_w - 100) * value, p.y),
				0xFFBBBBBB, 10
			)

			-- Border Left
			DL:AddLine(
				imgui.ImVec2(p.x + 50, p.y - 5),
				imgui.ImVec2(p.x + 50, p.y + 5),
				0xFF0000FF, 2
			)
			DL:AddText(imgui.ImVec2(p.x + 47, p.y + 15), 0xAAFFFFFF, "0")
			
			-- Border Right
			DL:AddLine(
				imgui.ImVec2(p.x + max_w - 50, p.y - 5),
				imgui.ImVec2(p.x + max_w - 50, p.y + 5),
				0xFF0000FF, 2
			)
			DL:AddText(imgui.ImVec2(p.x + max_w - 53, p.y + 15), 0xAAFFFFFF, "1")

			-- Circle Process
			DL:AddCircleFilled(c, 30 * value, 0xFFBBBBBB, 30)

			-- Circle Border
			DL:AddCircle(c, 30, 0xFF0000FF, 30, 2)
		imgui.End()
    end
)