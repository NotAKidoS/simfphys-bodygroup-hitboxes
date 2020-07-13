return {
    HandleTruck = function(truck)
        if truck.connection then -- checks if trailer connected
            local trailer = truck.connection.ent
            if trailer:GetModel()=="models/gtasa/vehicles/bagboxb/bagboxb.mdl" then -- checks if model right
                local AlignedSteering = math.AngleDifference(truck.ent:EyeAngles().y,trailer:EyeAngles().y)
                trailer:SteerVehicle(math.Clamp(-AlignedSteering, -15, 15))
            end
        end
    end
}
