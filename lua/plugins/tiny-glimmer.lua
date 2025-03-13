return {
  "rachartier/tiny-glimmer.nvim",
  opts = {
    refresh_interval_ms = 6,
    overwrite = {
      auto_map = true,
      paste = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "DiffText",
          },
        },
      },
      undo = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "DiffDelete",
          },
        },
      },
      redo = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "DiffAdd",
          },
        },
      },
    },
    --  support = {
    --    substitute = {
    --      enabled = true,
    --      default_animation = "fade",
    --    },
    --  },
    animations = {
      fade = {
        chars_for_max_duration = 1,
        to_color = "Folded"
      },
    }
  },
}
