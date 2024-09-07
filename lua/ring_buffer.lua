local RingBuffer = {}
RingBuffer.__index = RingBuffer

function RingBuffer.new(capacity)
  local buffer = setmetatable({
    capacity = capacity,
    buffer = {},
    start = 1,
    size = 0,
  }, RingBuffer)

  return buffer
end

function RingBuffer:push(item)
  if self.size < self.capacity then
    table.insert(self.buffer, item)
    self.size = self.size + 1
  else
    self.buffer[self.start] = item
    self.start = (self.start % self.capacity) + 1
  end
end

function RingBuffer:get(index)
  if index > self.size then return nil end
  local real_index = (self.start + index - 2) % self.capacity + 1
  return self.buffer[real_index]
end

function RingBuffer:get_last()
  local index = self.size
  local real_index = (self.start + index - 2) % self.capacity + 1
  return self.buffer[real_index]
end

function RingBuffer:get_size()
  return self.size
end

return RingBuffer
