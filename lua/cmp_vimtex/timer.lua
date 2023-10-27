-- Part of https://github.com/hrsh7th/cmp-buffer
--
-- MIT License
--
-- Copyright (c) 2021 hrsh7th
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---This timer matches the semantics of setInterval and clearInterval of
---Javascript. It provides a more reliable alternative to vim.loop.timer_start
---with a callback wrapped into a vim.schedule call by addressing two problems:
---1. Scheduled callbacks are invoked less frequently than a libuv timer with a
---   small interval (1-5ms). This causes those callbacks to fill up the queue
---   in the event loop, and so the callback function may get invoked multiple
---   times on one event loop tick. In contrast, Javascript's setInterval
---   guarantees that the callback is not invoked more frequently than the
---   interval.
---2. When a libuv timer is stopped with vim.loop.timer_stop, it doesn't affect
---   the callbacks that have already been scheduled. So timer_stop will not
---   immediately stop the timer, the actual callback function will run one
---   more time until it is finally stopped. This implementation ensures that
---   timer_stop prevents any subsequent invocations of the callback.
---
---@class cmp_buffer.Timer
---@field public handle any
---@field private callback_wrapper_instance fun()|nil
local timer = {}

function timer.new()
  local self = setmetatable({}, { __index = timer })
  self.handle = vim.loop.new_timer()
  self.callback_wrapper_instance = nil
  return self
end

---@param timeout_ms number
---@param repeat_ms number
---@param callback fun()
function timer:start(timeout_ms, repeat_ms, callback)
  -- This is the flag that fixes problem 1.
  local scheduled = false
  -- Creating a function on every call to timer_start ensures that we can always
  -- detect when a different callback is set by calling timer_start and prevent
  -- the old one from being invoked.
  local function callback_wrapper()
    if scheduled then
      return
    end
    scheduled = true
    vim.schedule(function()
      scheduled = false
      -- Either a different callback was set, or the timer has been stopped.
      if self.callback_wrapper_instance ~= callback_wrapper then
        return
      end
      callback()
    end)
  end
  self.handle:start(timeout_ms, repeat_ms, callback_wrapper)
  self.callback_wrapper_instance = callback_wrapper
end

function timer:stop()
  self.handle:stop()
  self.callback_wrapper_instance = nil
end

function timer:is_active()
  return self.handle:is_active()
end

function timer:close()
  self.handle:close()
end

return timer
