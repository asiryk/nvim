local M = {}

-- Result(pcall(require, "asdfasdf"))
--   :Ok(function (result) vim.pretty_print(result) end)
--   :Err(function () print("there is an error") end)
function M.Result(is_present, result, ...)
   local argv = { ... }

   return {
      Ok = function(self, func)
         if is_present then
            func(result, table.unpack(argv))
         end

         return { Err = self.Err }
      end,

      Err = function(self, func)
         if not is_present then
            func()
         end

         return { Ok = self.Ok }
      end
   }
end

return M
