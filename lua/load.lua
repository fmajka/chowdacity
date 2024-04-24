-- NOTE: Sprite module contains state, hot-reloading it will crash
Sprite = require("utils.sprite")

-- NOTE: locals aren't very hot-reloadable
local require = require("utils.rerequire")

Colors = require("Colors")
Level = require("Level")

Vector = require("components.Vector")

CameraSystem = require("systems.CameraSystem")
TileRenderer = require("systems.TileRenderer")
