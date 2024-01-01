local notify = require("notify")
notify.setup({
  -- render = "compact",
  timeout = 5000,
  stages = "slide",
  -- stages = anim(Dir.TOP_DOWN),
})


vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings") then
        return
    end

    notify(msg, ...)
end
