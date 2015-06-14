winbox Cookbook
===============
The *winbox* cookbook configures Windows workstations for development. It configures the following features on a system:

* [Git](http://www.git-scm.com/) for source control
* A text editor (configurable, [VSCode](https://code.visualstudio.com/) by default)
* [ConEmu](https://conemu.github.io/) terminal replacement
* [Chocolatey](https://chocolatey.org) package manager
* [PSGet](https://github.com/psget/psget) PowerShell module package manager
* [PSReadline](https://github.com/lzybkr/PSReadLine) module for PowerShell
* Other environmental settings optimized for development

*Winbox* is for developers regardless of platform background:

* **Windows experts:** you live and breathe Windows, maybe a lot of C#,
  .NET, and PowerShell and even Win32 API. The tools in this cookbook
  are best of breed for that kind of work!
* **Unix users on Windows:** you're primarily a Linux-focused developer
  who, for whatever reason, finds herself using Windows. This
  toolset makes sure you won't feel lost without standard-issue Linux
  capabilities such as a usable terminal, remote package manager, and
  real text editors with programming language syntax support.

Requirements
------------
This cookbook supports only the Windows operating system. It requires
Windows Server 2008 R2 / Windows 7 or later.

For the local workstation configuration use case (i.e. where you're
not managing the node via a Chef Server), you must have the following
prerequisites installed:

* `chef-client` and `berkshelf`: to install these, just install the
  [Chef-DK](https://downloads.chef.io/chef-dk), which includes them.
* `git`: You can install `git` for Windows by visiting
  [Github](http://msysgit.github.io/) in case you don't already have a
  package manager.

## Local workstation configuration
If your goal is to configure a local workstation (possibly the one
you're using to read this) without using a Chef Server, simply do the
following from a PowerShell session:

```powershell
# Clone this repository and cd to it
git clone https://github.com/adamedx/winbox
cd winbox

# Use Berkshelf to download all cookbook dependencies:
berks vendor cookbooks

# Run `chef-client` in local mode to configure the workstation!
chef-client -z --color -o 'winbox'
```

After a brief period of downloading and installing features and
configuring the system, your workstation should be ready to go!

## Using with your Chef Server

This cookbook can be used on a managed Chef node like any other cookbook simply by uploading
the cookbook to your Chef Server and configuring a node via bootstrap
or setting the node's runlist to use a recipe. You can then configure it by
converging it with a `chef-client` run.

### winbox::default
Use this recipe to get common tools required for development.

## Using your workstation
All right, you've installed everything, so what can you do? Here are a
few things to try:

* **Run ConEmu!** ConEmu should be available on your Start Menu /
Screen, or by running ConEmu64.exe from within a command-line shell.
ConEmu is a replacement for the limited terminal application used by
default on Windows. The ConEmu terminal is much more like those on
Linux desktop systems; the window is resizable, it supports ANSI color
sequences, line-wrapped (instead of block) text selection, and many,
many other advanced features. By default, ConEmu will run a PowerShell
session in its terminal, though it can be configured to run a
different shell.
* **Use PSReadline with PowerShell!** You should already be using
PowerShell as your command-line shell and primary method of
interacting with Windows. If you're not familiar with
[PSReadline](https://github.com/lzybkr/PSReadLine), it enhances any
PowerShell, even those run in the default terminal application, so
that Emacs-style line editing keyboard shortcuts including command
history search are available when editing commands. This makes the
experience of using PowerShell very similar to Unix shells like `bash`,
which support this editing capability by default.
* **Use a real text editor** to edit... code! Whether it's Ruby, C++,
C#, Java, or PowerShell, any of the editors installed by this cookbook
can perform syntax highlighting and in general offer the advanced
editing capabilities required by developers. By default, the cookbook
will install [Visual Studio Code](https://code.visualstudio.com/); you
can override this default using the cookbook's `editor` attribute --
see subsequent sections for details on configuring other editors
such as Atom, Emacs, and Vim.
* **Install software using Chocolatey.** The Chocolatey package
  manager is similar to those on Linux. Try it out -- usage is similar
  to `apt-get` on Debian systems:
  `choco install sysinternals`
* **Install PowerShell modules using PSGet.** [PSGet](https://github.com/psget/psget)
  is like Chocolatey, except it's focused on PowerShell modules rather than
  applications:
  `install-module pester`
* **Get detailed command help** with *man*. PowerShell provides a
  default alias `man` for the `get-help` cmdlet which is similar to
  the Unix `man` command. Unfortunately, this useful alias defaults to
  giving very limited help, requiring you to remember to pass the
  `-full` switch to `man`. This cookbook redefines the alias so that
  it gives full help by default.
* **Add some color to your PowerShell prompt**. You'll only see this
  feature if you don't already have a PowerShell profile (see the
  `$PROFILE` variable in PowerShell for the location of this file). If
  you don't have one, this cookbook creates one for you that will add
  color to the prompt and also show the name of the system you're
  using along with your username. For advanced usage, it shows the
  exit code of the last Windows process launched by the shell, and the
  prompt changes color based the success or failure of the last
  PowerShell cmdlet that was executed.
* **Get to your Documents directory fast**. This cookbook defines an
  alias `docs` that will change your current directory to your
  *Documents* directory, even if it's configured to a network
  location. Very useful since Windows developer workstations often
  contain more traditional "document" content. Consider this one a
  bonus feature.

### Advanced usage and notes

Advanced usage includes customizing the file `~/winbox-ps-profile.ps1`
used by this cookbook's PowerShell profile. Editing this file is an
easy way to update the PowerShell profile directly.

Here is additional behavior related to PowerShell profiles:

* The cookbook never alters an existing PowerShell profile.
* To use this cookbook's PowerShell profile if you have an existing
  profile, rename your PowerShell profile and run the `powershell_dev`
  recipe or any other recipe such as `default` that includes it.
* The PowerShell profile used by this cookbook actually uses the
  content in `/winbox-ps-profile.ps1`, which is not updated if it
  already exists. To get profile changes from subsequent revisions of
  the cookbook, rename `~/winbox-ps-profile.ps1` and re-run the
  correct recipe.
* Note that because `~/winbox-ps-profile.ps1` is not updated by this
  cookbook if it exists, it's safe for you to edit its content to
  customize your profile.

## Recipe inventory

In addition to the default recipe, additional recipes with more
focused functionality may be used.

### winbox::chocolatey_install
Install the Chocolatey package manager.

### winbox::console
Installs ConEmu for Windows as an alternative to the built-in terminal (console) in Windows.

### winbox::powershell_dev
Sets PowerShell execution policy for Windows so you can run PowerShell
scripts

### winbox::readline
Installs the PSReadline module for Readline emulation with PowerShell.

### winbox::editor
Installs a text editor -- the default is Visual Studio Code, which can
be overridden via the `editor` attribute for this cookbook.

### Recipe customization

The following attributes can be used to customize the cookbook's
behavior:

#### `editor` attribute

The `editor` attribute determines the text editor to install via the
`editor` (and thus `default`) recipes. It's not mandatory to specify
its value explicitly since it has a default value, but it **must** be
st to a valid value if its overridden:

| `editor` value | Description                                           |
|----------------|-------------------------------------------------------|
| `:vscode`      | **Default**. Sets the editor to *Visual Studio Code*. |
| `:atom`        | Sets the editor to the Atom editor.                   |
| `:emacs`       | Sets the editor to the Emacs.                         |
| `:vim`         | Sets the editor to Vim                                |

## TODO

* Change this cookbook to a resource-only cookbook

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

