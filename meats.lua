package.preload["lummander"] = package.preload["lummander"] or function(...)
  local Lummander = require"lummander.lummander"
  
  return Lummander
end
local db
package.preload["flat"] = package.preload["flat"] or function(...)
  local mp = require("MessagePack")
  
  local function isFile(path)
  	local f = io.open(path, "r")
  	if f then
  		f:close()
  		return true
  	end
  	return false
  end
  
  local function isDir(path)
  	path = string.gsub(path.."/", "//", "/")
  	local ok, err, code = os.rename(path, path)
  	if ok or code == 13 then
  		return true
  	end
  	return false
  end
  
  local function load_page(path)
  	local ret
  	local f = io.open(path, "rb")
  	if f then
  		ret = mp.unpack(f:read("*a"))
  		f:close()
  	end
  	return ret
  end
  
  local function store_page(path, page)
  	if type(page) == "table" then
  		local f = io.open(path, "wb")
  		if f then
  			f:write(mp.pack(page))
  			f:close()
  			return true
  		end
  	end
  	return false
  end
  
  local pool = {}
  
  local db_funcs = {
  	save = function(db, p)
  		if p then
  			if type(p) == "string" and type(db[p]) == "table" then
  				return store_page(pool[db].."/"..p, db[p])
  			else
  				return false
  			end
  		end
  		for p, page in pairs(db) do
  			if not store_page(pool[db].."/"..p, page) then
  				return false
  			end
  		end
  		return true
  	end
  }
  
  local mt = {
  	__index = function(db, k)
  		if db_funcs[k] then return db_funcs[k] end
  		if isFile(pool[db].."/"..k) then
  			db[k] = load_page(pool[db].."/"..k)
  		end
  		return rawget(db, k)
  	end
  }
  
  pool.hack = db_funcs
  
  return setmetatable(pool, {
  	__mode = "kv",
  	__call = function(pool, path)
  		assert(isDir(path), path.." is not a directory.")
  		if pool[path] then return pool[path] end
  		local db = {}
  		setmetatable(db, mt)
  		pool[path] = db
  		pool[db] = path
  		return db
  	end
  })
end
db = require("flat")("./db")
local L = require("lummander")
local view = require("fennel.view")
local function iter__3etable(iter)
  local tbl_14_auto = {}
  local i_15_auto = #tbl_14_auto
  for v in iter do
    local val_16_auto = v
    if (nil ~= val_16_auto) then
      i_15_auto = (i_15_auto + 1)
      do end (tbl_14_auto)[i_15_auto] = val_16_auto
    else
    end
  end
  return tbl_14_auto
end
local function disarray(map)
  local tbl_14_auto = {}
  local i_15_auto = #tbl_14_auto
  for k, v in pairs(map) do
    local val_16_auto = {entry = string.format("%s:%s:%s", k, v.x, v.y), hot = v.hot}
    if (nil ~= val_16_auto) then
      i_15_auto = (i_15_auto + 1)
      do end (tbl_14_auto)[i_15_auto] = val_16_auto
    else
    end
  end
  return tbl_14_auto
end
local cli = L.new({title = "meats", tag = "meats", description = "file + position store for text editors, make sure to have a db directory besides this boy", theme = "acid"})
local function _3_(parsed, command, app)
  local disarrayed = disarray(db.meats)
  local sorting_done
  local function _4_(a, b)
    return (a.hot > b.hot)
  end
  sorting_done = table.sort(disarrayed, _4_)
  local _let_5_ = disarrayed
  local head = _let_5_[1]
  local tail = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_let_5_, 2)
  local function _6_()
    local acc = head.entry
    for ix, el in ipairs(tail) do
      acc = (acc .. "\n" .. el.entry)
    end
    return acc
  end
  return print((_6_() .. "\n"))
end
cli:command("flash", "show your meat"):action(_3_)
local function _7_(parsed, command, app)
  db.meats = {}
  return db:save()
end
cli:command("eat", "empty the grill"):action(_7_)
local function _8_(parsed, command, app)
  local _let_9_ = iter__3etable(string.gmatch(parsed.meat, "([^:]+)"))
  local file = _let_9_[1]
  local maybe_more = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_let_9_, 2)
  do end (db)["meats"][file] = nil
  return db:save()
end
cli:command("taste <meat>", "eat one up"):action(_8_)
local function _10_(parsed, command, app)
  local _let_11_ = iter__3etable(string.gmatch(parsed.meat, "([^:]+)"))
  local file = _let_11_[1]
  local pos_x = _let_11_[2]
  local pos_y = _let_11_[3]
  local meat = _let_11_
  db["meats"][file] = {x = pos_x, y = pos_y, hot = os.time()}
  return db:save()
end
cli:command("stab <meat>", "streak a meat on top of the rest"):action(_10_)
return cli:parse(arg)
