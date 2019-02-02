import sublime, sublime_plugin

class RepeatSinceMovement(sublime_plugin.TextCommand):
    def run(self, edit):
        i = 0
        commands = []
        for _ in range(1000):
            command_name, args, repeat = self.view.command_history(-i, modifying_only=False)
            i += 1
            if not command_name:
                break
            if command_name == 'smart_repeat':
                continue
            if command_name in ('move', 'drag_select',):
                if commands:
                    break
                else:
                    continue
            commands.append((command_name, args, repeat,))
        for command_name, args, repeat in commands[::-1]:
            for i in range(repeat):
                self.view.run_command(command_name, args)
