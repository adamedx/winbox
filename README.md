winbox Cookbook
===============
The *winbox* cookbook configures Windows and Linux workstations for development. It configures the following features on a system:

* Git for source control
* A text editor
* Terminal
* Package manager
* Other environmental settings optimized for development

Requirements
------------
This cookbook supports only the Windows operating system. It requires
Windows Server 2008 R2 / Windows 7 or later.

Usage
-----

#### winbox::default
Add this cookbook to your runlist and converge the node -- you'll get
defaults for everything (`git`, editor, terminal, etc.).

#### winbox::chocolatey_install
Install the Chocolatey package manager.

#### winbox::console
Installs ConEmu for Windows as an alternative to the built-in terminal (console) in Windows.

#### winbox::powershell_dev
Sets PowerShell execution policy for Windows so you can run PowerShell
scripts

#### winbox::readline
Installs the PSReadline module for Readline emulation with PowerShell.

#### winbox::editor
Installs a text editor -- the default is Visual Studio Code, which can
be overridden via the `editor` attribute for this cookbook.

## Customization

The following attributes can be used to customize the cookbook's
behavior:

#### `editor` attribute

The `editor` attribute determines the text editor to install via the
`editor` (and thus `default) recipes. It's not mandatory to specify
its value explicitly since it has a default value, but it **must** be
st to a valid value if its overridden:

| `editor` value | Description                                           |
|----------------|-------------------------------------------------------|
| `:vscode`      | **Default**. Sets the editor to *Visual Studio Code*. |
| `:atom`        | Sets the editor to the Atom editor.                   |
| `:emacs`       | Sets the editor to the Emacs.                         |

License and Authors
-------------------
Copyright:: Copyright (c) 2015 Adam Edwards

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

