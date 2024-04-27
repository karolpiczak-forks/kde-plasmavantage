# PlasmaVantage for Plasma 6

This plasmoid allows you to easily control features of your Lenovo Legion laptop series such as battery fast charging, conservation mode, hybrid graphics and more that are exposed by the [LenovoLegionLinux](https://github.com/johnfanv2/LenovoLegionLinux) and Ideapad kernel modules.

## Requirements

- [LenovoLegionLinux](https://github.com/johnfanv2/LenovoLegionLinux) kernel module
- Ideapad kernel module (Included in mainline Linux)

## Disclaimer

- This is just a hobby project and is **not affiliated with Lenovo in any way**.
- This plasmoid just uses sysfs interfaces provided by LenovoLegionLinux and ideapad modules. Since Lenovo never officially supported these interfaces on Linux, many of them were discovered through reverse engineering and ACPI disassembling.
Therefore, just like LLL or the Linux kernel, **this comes with no warranty and you should only use this at your own risk**.

## Issues

- The controls state will not refresh if the plasmoid is expanded and the user uses Fn buttons or another tool to switch one of the controls.

## Translations

Coming soon...

## Roadmap / TODO

- [ ] Improve look and feel
- [ ] Customize and rearrange controls
- [ ] Customize plasmoid/tray icon
- [ ] Add icons-only compact mode
- [ ] Propose to reboot for settings that need it to apply
- [ ] Password-less operation
- [ ] Notifications / OSD
- [ ] Requirements checks & error detection

## License

Mozilla Public License 2.0.

## Credits

Some of the icons used in this project are derivative work from [SVGRepo](https://www.svgrepo.com).
