-- 2D Vector class

Vector = {}
Vector.__index = Vector

Vector.__add = function(a, b)
    if type(a) == "number" then
        return Vector(b.x + a, b.y + a)
    elseif type(b) == "number" then
        return Vector(a.x + b, a.y + b)
    else
        return Vector(a.x + b.x, a.y + b.y)
    end
end

Vector.__sub = function(a, b)
    if type(a) == "number" then
        return Vector(a - b.x, a - b.y)
    elseif type(b) == "number" then
        return Vector(a.x - b, a.y - b)
    else
        return Vector(a.x - b.x, a.y - b.y)
    end
end

Vector.__mul = function(a, b)
    if type(a) == "number" then
        return Vector(b.x * a, b.y * a)
    elseif type(b) == "number" then
        return Vector(a.x * b, a.y * b)
    else
        return Vector(a.x * b.x, a.y * b.y)
    end
end

Vector.__div = function(a, b)
    if type(a) == "number" then
        return Vector(a / b.x, a / b.y)
    elseif type(b) == "number" then
        return Vector(a.x / b, a.y / b)
    else
        return Vector(a.x / b.x, a.y / b.y)
    end
end

Vector.__eq = function(a, b)
    return a.x == b.x and a.y == b.y
end

Vector.__lt = function(a, b)
    return a.x < b.x or (a.x == b.x and a.y < b.y)
end

Vector.__le = function(a, b)
    return a.x <= b.x and a.y <= b.y
end

Vector.__tostring = function(a)
    return "(" .. a.x .. ", " .. a.y .. ")"
end

setmetatable(Vector, {
    __call = classCall
})

function Vector:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vector.distance(a, b)
    return (b - a):len()
end

function Vector:clone()
    return Vector(self.x, self.y)
end

function Vector:unpack()
    return self.x, self.y
end

function Vector:len()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:lenSq()
    return self.x * self.x + self.y * self.y
end

function Vector:normalize()
    local len = self:len()
    self.x = self.x / len
    self.y = self.y / len
    return self
end

function Vector:normalized()
    return self / self:len()
end

function Vector:floored()
    return Vector(math.floor(self.x), math.floor(self.y))
end

function Vector:rotate(phi)
    local c = math.cos(phi)
    local s = math.sin(phi)
    self.x = c * self.x - s * self.y
    self.y = s * self.x + c * self.y
    return self
end

function Vector:rotated(phi)
    return self:clone():rotate(phi)
end

function Vector:perpendicular()
    return Vector(-self.y, self.x)
end

function Vector:projectOn(other)
    return (self * other) * other / other:lenSq()
end

function Vector:cross(other)
    return self.x * other.y - self.y * other.x
end

function Vector:dot(other)
    return self.x * other.x + self.y * other.y
end
