--
-- Patch robo chests to have 4 charging points instead of 1
--
for _,name in pairs({ "bob-robochest", "bob-robochest-2", "bob-robochest-3", "bob-robochest-4" }) do
  local obj = data.raw["roboport"][name]
  if obj ~= nil then
    --log("%%% tweaking "..name)
    obj.charging_offsets = { {-0.5, -0.5}, {0.5, -0.5}, {-0.5, 0.5}, {0.5, 0.5}, }
  end
end


--
-- Create a zone expander that has a small logistics radius and no construction radius
--
local entity = data.raw["roboport"]["bob-logistic-zone-expander"]
local item = data.raw["item"]["bob-logistic-zone-expander"]
local tech = data.raw["technology"]["bob-robo-modular-1"]

if entity ~= nil and item ~= nil and tech ~= nil then
  local name = "tritano-logistic-zone-expander-1"
  --log("%%% creating "..name)

  entity = table.deepcopy(entity);
  entity.name = name
  entity.minable.result = entity.name
  entity.logistics_radius = 5
  entity.construction_radius = 0

  item = table.deepcopy(item)
  item.name = name
  item.place_result = name
  item.order = item.order:gsub("%d*]$", "zzz-"..name.."]")

  table.insert(tech.effects, { type = "unlock-recipe", recipe = name })

  data.raw["roboport"][name] = entity
  data.raw["item"][name] = item
  data:extend({
  {
    type = "recipe",
    name = name,
    enabled = "false",
    ingredients =
    {
      {"steel-plate", 3},
      {"roboport-antenna-1", 1},
    },
    result = name,
    energy_required = 2
  }})
end

