return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    -- include the bottom line in folded text for additional context
    local handler = function(virtText, _, endLnum, width, truncate, ctx)
      local filling = table.concat({ ' ', tools.ui.icons.ellipses, ' ' })
      table.insert(virtText, { filling, 'Folded' })
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      local endVirtText = ctx.get_fold_virt_text(endLnum)
      for i, chunk in ipairs(endVirtText) do
        local chunkText = chunk[1]
        local hlGroup = chunk[2]
        if i == 1 then
          chunkText = chunkText:gsub("^%s+", "")
        end
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(virtText, { chunkText, hlGroup })
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          table.insert(virtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      return virtText
    end

    require('ufo').setup({
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = handler,
      open_fold_hl_timeout = 0,
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end
    })
  end,
}
