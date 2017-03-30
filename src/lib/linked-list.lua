-- Doubly linked list implementation

rawnext = next
function next(t,k)
    local m = getmetatable(t)
    local n = m and m.__next or rawnext
    return n(t,k)
end
function pairs(t) return next, t, nil end

function classCall(cls, ...)
    local self = setmetatable({}, cls)
    self:new(...)
    return self
end

local LLIterator = {}
LLIterator.__index = LLIterator
LLIterator.__next = function(it, key)
    if key and key >= it:get().size then
        return nil
    end
    return it:next()
end

setmetatable(LLIterator, {
    __call = classCall
})

function LLIterator:new(ll)
    self.ll = ll
    self.currentIndex = 0
    self.current = nil
end

function LLIterator:get()
    return self.ll
end

function LLIterator:next()
    local ind = self.currentIndex + 1
    
    if ind == 1 then
        self.current = self.ll.head
    else
        self.current = self.current.next
    end
    self.currentIndex = ind

    return ind, self.current.value
end

local LinkedList = {}
LinkedList.__index = function(ll, key)
    if type(key) == 'number' and key % 1 == 0 then
        return ll:get(key)
    else
        return rawget(LinkedList, key)
    end
end
LinkedList.__tostring = function(ll)
    local str = ''
    for i,v in pairs(ll:iterator()) do
        if #str > 0 then
            str = str .. ','
        end
        str = str .. tostring(v)
    end
    return string.format('(%s)', str)
end

setmetatable(LinkedList, {
    __call = classCall
})

function LinkedList:new(...)
    self.head = nil
    self.tail = nil
    self.size = 0
end

-- add to the front
function LinkedList:addFirst(val)
    local v = {
        value = val,
        next = self.head,
        prev = nil
    }
    if not self.tail then -- empty
        self.tail = v
    end
    if self.head then
        self.head.prev = v
    end
    self.head = v
    self.size = self.size + 1
end

-- add to the back
function LinkedList:add(val)
    local v = {
        value = val,
        next = nil,
        prev = self.tail
    }
    if self.tail and self.head then
        self.tail.next = v
    else
        self.head = v
    end
    self.tail = v
    self.size = self.size + 1
end

-- add to the back
function LinkedList:push(val)
    self:add(val)
end

-- get head
function LinkedList:peek()
    if self.head then
        return self.head.value
    else
        error("LinkedList is empty.")
    end
end

-- get tail
function LinkedList:peekLast()
    if self.tail then
        return self.tail.value
    else
        error("LinkedList is empty.")
    end
end

-- remove and return head
function LinkedList:poll()
    local ret = self:peek()
    self.head = self.head.next
    if not self.head then
        self.tail = nil
    else
        self.head.prev = nil
    end
    self.size = self.size - 1
    return ret
end

-- remove and return tail
function LinkedList:pop()
    local ret = self:peekLast()
    self.tail = self.tail.prev
    if not self.tail then
        self.head = nil
    else
        self.tail.next = nil
    end
    self.size = self.size - 1
    return ret
end

-- get i-th element
function LinkedList:get(i)
    if i < 1 or i > self.size then
        error("Out of bounds.")
    end
    if i == 1 then return self.head.value end
    if i == self.size then return self.tail.value end
    local left = i <= math.ceil(self.size / 2)
    local incr = left and 1 or -1

    local j = left and 1 or self.size
    local ret = left and self.head or self.tail
    while j ~= i do
        ret = left and ret.next or ret.prev
        j = j + incr
    end
    return ret.value
end

function LinkedList:iterator()
    return LLIterator(self)
end

function LinkedList:toList()
    local tbl = {}
    for i,v in pairs(self:iterator()) do
        tbl[i] = v
    end
    return tbl
end