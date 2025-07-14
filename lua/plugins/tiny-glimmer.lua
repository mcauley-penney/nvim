return {
  "rachartier/tiny-glimmer.nvim",
  opts = {
    refresh_interval_ms = 1,
    overwrite = {
      paste = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "CurSearch",
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
    animations = {
      fade = {
        to_color = "Normal",
        min_duration = 300,
        max_duration = 300,
        chars_for_max_duration = 1,
      },
      left_to_right = {
        to_color = "Normal",
        min_duration = 300,
        max_duration = 300,
        chars_for_max_duration = 1,
      },
    },
  },
}
