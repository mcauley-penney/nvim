return {
  {
    "rachartier/tiny-glimmer.nvim",
    opts = {
      refresh_interval_ms = 1,
      overwrite = {
        paste = {
          enabled = true,
          paste_mapping = "p",
          Paste_mapping = "P",
          default_animation = {
            name = "fade",
            settings = {
              from_color = "DiffText",
            },
          },
        },
        search = {
          enabled = true,
          next_mapping = "j",
          prev_mapping = "J",
          default_animation = {
            name = "fade",
            settings = {
              from_color = "DiffText",
            },
          },
        },
        undo = {
          enabled = true,
          undo_mapping = "u",
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
          chars_for_max_duration = 1,
          to_color = "Folded"
        },
      }
    },
  }
}
