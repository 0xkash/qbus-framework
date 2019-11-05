local cameraActive = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0

Citizen.CreateThread(function()
    while true do
        for a = 1, #SecurityCamConfig.Locations do
            local ped = GetPlayerPed(PlayerId())
            local pedPos = GetEntityCoords(ped, false)
            local pedHead = GetEntityRotation(ped, 2)
            if createdCamera ~= 0 then
                local instructions = CreateInstuctionScaleform("instructional_buttons")
                DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
                SetTimecycleModifier("scanline_cam_cheap")
                SetTimecycleModifierStrength(2.0)

                if Config.SecurityCameras.hideradar then
                    DisplayRadar(false)
                else
                    DisplayRadar(true)
                end

                -- CLOSE CAMERAS
                if IsControlJustPressed(1, Keys["BACKSPACE"]) then
                    CloseSecurityCamera()
                    SendNUIMessage({
                        type = "disablecam",
                    })
                end

                ---------------------------------------------------------------------------
                -- CAMERA ROTATION CONTROLS
                ---------------------------------------------------------------------------
                if SecurityCamConfig.Locations[currentCameraIndex].cameras[currentCameraIndexIndex].canRotate then
                    local getCameraRot = GetCamRot(createdCamera, 2)

                    -- ROTATE UP
                    if IsControlPressed(1, Keys["W"]) then
                        if getCameraRot.x <= 0.0 then
                            SetCamRot(createdCamera, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                        end
                    end

                    -- ROTATE DOWN
                    if IsControlPressed(1, Keys["S"]) then
                        if getCameraRot.x >= -50.0 then
                            SetCamRot(createdCamera, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                        end
                    end

                    -- ROTATE LEFT
                    if IsControlPressed(1, Keys["A"]) then
                        SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
                    end

                    -- ROTATE RIGHT
                    if IsControlPressed(1, Keys["D"]) then
                        SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('police:client:ActiveCamera')
AddEventHandler('police:client:ActiveCamera', function(cameraId)
    if Config.SecurityCameras.cameras[cameraId] ~= nil then
        local firstCamx = Config.SecurityCameras.cameras[cameraId].x
        local firstCamy = Config.SecurityCameras.cameras[cameraId].y
        local firstCamz = Config.SecurityCameras.cameras[cameraId].z
        local firstCamr = Config.SecurityCameras.cameras[cameraId].r
        SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
        ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
        SendNUIMessage({
            type = "enablecam",
            label = SecurityCamConfig.Locations[a].cameras[cameraId].label,
            box = "Security Cam",
        })
        currentCameraIndex = a
        currentCameraIndexIndex = 1
    elseif cameraId == 0 then
        CloseSecurityCamera()
        SendNUIMessage({
            type = "disablecam",
        })
    else
        QBCore.Functions.Notify("Camera bestaat niet..", "error")
    end
end)

---------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------
function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Citizen.Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    if SecurityCamConfig.HideRadar then
        DisplayRadar(true)
    end
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0*scale, 0.35*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function IsPedAllowed(ped, pedList)
    for i = 1, #pedList do
		if GetHashKey(pedList[i]) == GetEntityModel(ped) then
			return true
		end
	end
    return false
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Sluit Camera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end
