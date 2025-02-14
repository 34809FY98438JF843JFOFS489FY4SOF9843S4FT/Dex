local Main, Lib, Apps, Settings
local Explorer, Properties, ScriptViewer, Notebook
local API, RMD, env, service, plr, create, createSimple

local function initDeps(data)
	Main, Lib, Apps, Settings = data.Main, data.Lib, data.Apps, data.Settings
	API, RMD, env, service, plr = data.API, data.RMD, data.env, data.service, data.plr
	create, createSimple = data.create, data.createSimple
end

local function initAfterMain()
	Explorer, Properties, ScriptViewer, Notebook = Apps.Explorer, Apps.Properties, Apps.ScriptViewer, Apps.Notebook
end

local function main()
	local ScriptViewer = {}
	local window, codeFrame

	ScriptViewer.ViewScript = function(scr)
		local success, source = pcall(env.decompile or function() end, scr)
		if not success or not source then
			source = [[
local test = 5
local c = test + tick()
game.Workspace.Board:Destroy()
string.match("wow\'f", "yes", 3.4e-5, true)
game.Workspace.Wow
function bar() print(54) end
			]]
		end
		codeFrame:SetText(source)
		window:Show()
	end

	ScriptViewer.Init = function()
		window = Lib.Window.new()
		window:SetTitle("Script Viewer")
		window:Resize(650, 500)
		ScriptViewer.Window = window

		codeFrame = Lib.CodeFrame.new()
		codeFrame.Frame.Position = UDim2.new(0, 0, 0, 25)
		codeFrame.Frame.Size = UDim2.new(1, 0, 1, -50)
		codeFrame.Frame.Parent = window.GuiElems.Content

		local buttonFrame = Instance.new("Frame", window.GuiElems.Content)
		buttonFrame.BackgroundTransparency = 1
		buttonFrame.Size = UDim2.new(1, 0, 0, 25)

		local function createButton(text, pos, callback)
			local btn = Instance.new("TextButton", buttonFrame)
			btn.BackgroundTransparency = 0.3
			btn.Size = UDim2.new(0.5, 0, 1, 0)
			btn.Position = UDim2.new(pos, 0, 0, 0)
			btn.Text = text
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.GothamSemibold
			btn.TextSize = 14
			btn.TextStrokeTransparency = 0.8
			btn.TextButtonMode = Enum.TextButtonMode.Button
			btn.MouseButton1Click:Connect(callback)
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			btn.BorderColor3 = Color3.fromRGB(50, 50, 50)
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			end)
		end

		createButton("Copy to Clipboard", 0, function()
			setclipboard(codeFrame:GetText())
		end)

		createButton("Save to File", 0.5, function()
			local source = codeFrame:GetText()
			local filename = string.format("Script_%d_%d.txt", game.PlaceId, os.time())
			writefile(filename, source)
			if movefileas then
				movefileas(filename, ".txt")
			end
		end)
	end

	return ScriptViewer
end

if gethsfuncs then
	_G.moduleData = {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
else
	return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
end
