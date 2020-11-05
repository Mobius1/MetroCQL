require('__shared/config')

local MetroCQL = class("MetroCQL")

function MetroCQL:__init()
    self:RegisterVars()
    self:RegisterEvents()
end

function MetroCQL:RegisterVars()
    self.subWorldData = nil
    self.registryContainer = nil
    self.partition = nil
end

function MetroCQL:RegisterEvents()
    Events:Subscribe('Level:LoadResources', function(levelName, gameMode, isDedicatedServer)
        Events:Subscribe('Level:RegisterEntityResources', self, self.OnRegisterEntityResources)

        self:RegisterLoadHandlers()
    end)
end

function MetroCQL:RegisterLoadHandlers()
    -- Update combat zone to allow players in the park area
    for Team, Zone in pairs(Config.Redzones) do
        ResourceManager:RegisterInstanceLoadHandler(Config.LogicPartition, Zone.Guid, function(instance)
            self:ReplacePoints(instance, Zone.Points)
        end)
    end

    print("MetroCQL: Combat Zones Updated")

    ResourceManager:RegisterInstanceLoadHandler(Config.LogicPartition, Config.Redzones.US.HQ.Guid, function(instance)
        instance = ReferenceObjectData(instance)
        instance:MakeWritable()

        instance.blueprintTransform.trans = Config.Redzones.US.HQ.Pos

        print("MetroCQL: US HQ Updated")
    end)    

    -- Remove combat area texture asset from minimap
    -- TODO: Create new minimap redzone texture when RIME releases
    ResourceManager:RegisterInstanceLoadHandler(Guid('65214F82-8127-4ECD-B614-BF3B35C97787'), Guid('B8A18593-D1F7-4794-B96C-B349F3AC6459'), function(instance)
        instance = VeniceUICombatAreaAsset(instance)
        instance:MakeWritable()
        instance.distanceField = nil
        instance.surroundingDistanceField = nil

        print("MetroCQL: US Combat Area Asset Removed")
    end)

    ResourceManager:RegisterInstanceLoadHandler(Guid('601776CA-D1A8-432D-9F86-26BFF9E0EFB3B'), Guid('EA634590-B1EA-4056-8299-21EAF40D3520'), function(instance)
        instance = VeniceUICombatAreaAsset(instance)
        instance:MakeWritable()
        instance.distanceField = nil
        instance.surroundingDistanceField = nil

        print("MetroCQL: RU Combat Area Asset Removed")
    end)
end

function MetroCQL:OnRegisterEntityResources()
    self.subWorldData = SubWorldData(ResourceManager:SearchForDataContainer(Config.DataContainer))
    self.subWorldData:MakeWritable()

    self.registryContainer = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Config.RegistryContainer))
    self.registryContainer:MakeWritable()    

    -- Add new flags
    self.partition = ResourceManager:FindDatabasePartition(Config.LogicPartition)

    for _, instance in pairs(self.partition.instances) do
        if instance.instanceGuid == Config.LogicWorldPart then
            instance = WorldPartData(instance)
            instance:MakeWritable()

            -- Create new capture flags
            for _, flag in ipairs(Config.Flags) do
                self:AddCapturePoint(flag, instance)
            end
        end
    end

    print("MetroCQL: New Capture Points Added")
    
    self:ModifyUSSpawnPoints()
end

function MetroCQL:AddCapturePoint(flag, instance)
    local captureFlag = ReferenceObjectData(flag.Guid)

    captureFlag.blueprintTransform = LinearTransform()
    captureFlag.blueprintTransform.trans = flag.Pos

    captureFlag.blueprint           = SpatialPrefabBlueprint(ResourceManager:SearchForInstanceByGuid(flag.Prefab))
    captureFlag.excluded            = false
    captureFlag.streamRealm         = 0
    captureFlag.castSunShadowEnable = true

    -- Set index
    if flag.Letter == "D" then
        captureFlag.indexInBlueprint = 50
    elseif flag.Letter == "E" then
        captureFlag.indexInBlueprint = 51
    end

    captureFlag.isEventConnectionTarget     = 3
    captureFlag.isPropertyConnectionTarget  = 2
    
    -- Add flag to partition
    self.partition:AddInstance(captureFlag)
    
    -- Add flag to instance
    instance.objects:add(captureFlag)

    self.registryContainer.referenceObjectRegistry:add(captureFlag)

    local captureArea       = VolumeVectorShapeData(MathUtils:RandomGuid())
    captureArea.tension     = 0.0
    captureArea.isClosed    = true
    captureArea.allowRoll   = false  

    for _, point in ipairs(flag.CaptureArea) do
        captureArea.points:add(point)
        captureArea.normals:add(Vec3(0.0, 1.0, 0.0))
    end

    self:AddConnections(captureFlag, captureArea, flag.Letter)

    -- Capture Label
    self:AddCaptureLabel(captureFlag, flag.Label)

    -- Add spawn points
    for teamID, spawns in ipairs(flag.Spawns) do
        self:AddSpawnPoints(captureFlag, teamID, spawns)
    end
end

function MetroCQL:AddSpawnPoints(captureFlag, teamID, spawns)
    for _, spawn in ipairs(spawns) do
        -- Create the spawn point
        local spawnPoint = self:CreateSpawnPoint(teamID, spawn)

        -- Link the spawn point to flag
        self:AddLinkConnection(captureFlag, spawnPoint, -2001390482, 0)
    end
end

function MetroCQL:CreateSpawnPoint(team, transform)
    local spawnEntityData = AlternateSpawnEntityData(MathUtils:RandomGuid())
    spawnEntityData.team = team
    spawnEntityData.transform = transform
    spawnEntityData.isEventConnectionTarget = 2
    spawnEntityData.isPropertyConnectionTarget = 3
    
    return spawnEntityData
end

function MetroCQL:ModifyUSSpawnPoints()
    local Spawns = Config.Redzones.US.HQ.Spawns

    for _, Spawn in ipairs(Spawns) do
        self:ModifySpawnPoint(Spawn)
    end
end

function MetroCQL:ModifySpawnPoint(spawn)
    local instance = AlternateSpawnEntityData(ResourceManager:SearchForInstanceByGuid(spawn.Guid))
    instance:MakeWritable()

    instance.transform = spawn.Transform
end

-- Add connections
function MetroCQL:AddConnections(flag, area, letter)
    -- Link capture area to flag
    -- This will enable the flag to be captured when a player enters the capture area
    self:AddLinkConnection(flag, area, 838548383, 0)
    
    -- Voiceover confirmation
    -- This enables the voice over confirmation when the flag is captured / lost
    self:AddVoiceOverConnection(flag)

    -- This sets the letter of the capture flag
    local source = ReferenceObjectData(ResourceManager:SearchForInstanceByGuid(Guid('3B307FE6-E28E-4559-ADD0-FECE30C7CD24')))

    if letter == "D" then
        self:AddPropertyConnection(source, flag, 976418952, 912861179)
    elseif letter == "E" then
        self:AddPropertyConnection(source, flag, -881081335, 912861179)
    end

    -- UI/UIConquestEventsToOnscreenText
    local logicReference = LogicReferenceObjectData(ResourceManager:SearchForInstanceByGuid(Guid('9BDD55BB-93CA-4BC8-80D0-A01BEC663D26')))

    self:AddEventConnection(flag, logicReference, 2099208964 --[[ OnCaptured ]], -320316437, 3)
    self:AddEventConnection(flag, logicReference, -1433788352--[[ OnLost ]], 538417839, 3)

    self:AddEventConnection(flag, logicReference, 2099208964, -1704779190, 3) 
    self:AddEventConnection(flag, logicReference, -1433788352, 423451022, 3)     
end

function MetroCQL:AddCaptureLabel(flag, label)
    local interfaceData = InterfaceDescriptorData(ResourceManager:SearchForInstanceByGuid(Guid('184EB6A9-E532-8D64-0AC2-551AD903FF96')))
    interfaceData:MakeWritable()

    -- Generate the ID for the cature label otherwise it'll display "Untitled"
    local id = MathUtils:GetRandomInt(2000000000, 3000000000)
    
    local dataField = DataField()
    dataField.value = 'CString "' .. label .. '"'
    dataField.id = id
    dataField.accessType = 1
    
    interfaceData.fields:add(dataField)

    self:AddPropertyConnection(interfaceData, flag, id, 2025703195)
    self:AddPropertyConnection(interfaceData, flag, -77167751, -77167751)
end

-- This enables the voice over confirmation when the flag is captured / lost
function MetroCQL:AddVoiceOverConnection(flag)
    local logicReference = LogicReferenceObjectData(ResourceManager:SearchForInstanceByGuid(Guid('8A58EE67-B957-48A1-ACFF-676CC287F41C')))

    self:AddEventConnection(flag, logicReference, 2099208964, 2099208964, 3)
    self:AddEventConnection(flag, logicReference, -1433788352, -1433788352, 3)
end

function MetroCQL:AddLinkConnection(source, target, sourceId, targetId)
    local linkConnection            = LinkConnection()
    linkConnection.source           = source
    linkConnection.target           = target
    linkConnection.sourceFieldId    = sourceId
    linkConnection.targetFieldId    = targetId
                    
    -- Add link connection to subworld
    self.subWorldData.linkConnections:add(linkConnection) 
end

function MetroCQL:AddPropertyConnection(source, target, sourceId, targetId)
    local propertyConnection = PropertyConnection()
    propertyConnection.source = source
    propertyConnection.target = target
    propertyConnection.sourceFieldId = sourceId
    propertyConnection.targetFieldId = targetId 
        
    self.subWorldData.propertyConnections:add(propertyConnection)   
end

function MetroCQL:AddEventConnection(source, target, sourceID, targetID, targetType)
    local eventConnection   = EventConnection()
    local eventSpecSource   = EventSpec()
    local eventSpecTarget   = EventSpec()
    
    eventSpecSource.id      = sourceID
    eventSpecTarget.id      = targetID
    
    eventConnection.source = source
    eventConnection.target = target
    eventConnection.sourceEvent = eventSpecSource
    eventConnection.targetEvent = eventSpecTarget
    eventConnection.targetType = targetType
    
    self.subWorldData.eventConnections:add(eventConnection) 
end

function MetroCQL:ReplacePoints(instance, points)
    instance = VolumeVectorShapeData(instance)
    instance:MakeWritable()

    instance.points:clear()
            
    for _,point in pairs(points) do
        instance.points:add(point)
    end
end

return MetroCQL()