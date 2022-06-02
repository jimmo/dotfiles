commands = {
    "sf6_green": "connect id:334E33683138",
    "sf6_red": "connect id:336A33713138",
    "wb55_red": "connect id:205F3781594D",
    "wb55_green": "connect id:20633793594D",
    "bl": "bootloader",
    "littlefs": [
            "exec",
            "--no-follow",
            "import os, pyb, machine; os.umount('/flash'); os.VfsLfs2.mkfs(pyb.Flash(start=0)); os.mount(pyb.Flash(start=0), '/flash'); os.chdir('/flash'); machine.reset()",
    ],
}
