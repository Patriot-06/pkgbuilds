table.insert(alsa_monitor.rules,
  {
    matches = {
      {
        { "node.name", "matches", "alsa_output.platform-c051000.sound-card.HiFi__hw_*"  },
      },
      {
        { "node.name", "matches", "alsa_input.platform-c051000.sound-card.HiFi__hw_*"  },
      },
    },
    apply_properties = {
      ["node.pause-on-idle"]     = false,
      ["audio.format"]           = "S16LE",
      ["audio.rate"]             = 44100,
      --["audio.allowed-rates"]    = "32000,96000",
      ["api.alsa.headroom"]      = 2048,
      ["session.suspend-timeout-seconds"] = 0,
    },
  }
)
