import sys
sys.path.append('/home/jimmo/.config/mpremote')

commands = {
    "sf6_green": "connect id:334E33683138",
    "sf6_red": "connect id:336A33713138",
    "wb55_red": "connect id:205F3781594D",
    "wb55_green": "connect id:20633793594D",
    "rp2_f": "connect id:e6605838833ea938",
    "bl": "bootloader",
    "littlefs_stm": [
            "exec",
            "--no-follow",
            "import os, pyb, machine; os.umount('/flash'); os.VfsLfs2.mkfs(pyb.Flash(start=0)); os.mount(pyb.Flash(start=0), '/flash'); os.chdir('/flash'); machine.reset()",
    ],
    "littlefs_rp2": [
            "exec",
            "--no-follow",
            "import os, machine, rp2; os.umount('/'); bdev = rp2.Flash(); os.VfsLfs2.mkfs(bdev, progsize=256); vfs = os.VfsLfs2(bdev, progsize=256); os.mount(vfs, '/'); machine.reset()",
    ],
    "littlefs_esp": [
            "exec",
            "--no-follow",
            "import os; os.umount('/'); os.VfsLfs2.mkfs(bdev); os.mount(bdev, '/'); machine.reset()",
    ],
    "ifconfig": [
            "exec",
            "import network; sta_if = network.WLAN(network.STA_IF); print(sta_if.ifconfig())",
    ]
}

try:
    import config_local
    commands.update(config_local.commands)
except:
    pass
