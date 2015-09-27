Winbox Cookbook
===============
The *Winbox* cookbook configures Windows workstations for developers. It configures Git, ChefDK, a text editor, and other tools so you can start using it for Chef, Ruby, and other development tasks.

## Installation

Copy the following command and paste it into a PowerShell session and run it to install *Winbox* and all its prerequisites:
```powershell
. { iwr https://raw.githubusercontent.com/adamedx/winbox/0.1.79/files/default/install.ps1 } |
iex;install-workstation
```
See additonal instructions for customization and advanced usage and non-default features.

## Features and usage

The *Winbox* cookbook configures the following features on a system:

* [Git](http://www.git-scm.com/) for source control
* A text editor (configurable, [VSCode](https://code.visualstudio.com/) by default)
* [ConEmu](https://conemu.github.io/) terminal replacement
* [Chocolatey](https://chocolatey.org) package manager
* [PSGet](https://github.com/psget/psget) PowerShell module package manager
* [PSReadline](https://github.com/lzybkr/PSReadLine) module for PowerShell
* Other environmental settings optimized for development

### Who should use this cookbook?

Everyone using Windows should use *Winbox*! It's for developers and operators regardless of platform background:

* **Windows users:** You live and breathe Windows. If you're a
  developer, that means a lot of C# / .NET, some C,
  PowerShell, and maybe even the Win32 API. The tools in this cookbook
  are best of breed for that kind of work. If you're new to
  development on Windows, this cookbook gives you the tools used by
  the most experienced Windows developers.
* **Unix users on Windows:** You're primarily a Linux-focused developer
  who finds herself using Windows. This
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
  [ChefDK](https://downloads.chef.io/chef-dk), which includes them.
* `git` (recommended): The best way to obtain this cookbook is by
  cloning it from its source on *Github*. You can install `git` for Windows by visiting
  [Github](http://msysgit.github.io/) in case you don't already have a
  package manager.

## Detailed installation -- your workstation
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

## Detailed features
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
  will install [Visual Studio Code](https://code.visualstudio.com/)
  which you can launch from PowerShell by executing the command
  `code`. You can override this default using the cookbook's `editor` attribute.
  See subsequent sections for details on configuring other editors
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
* **Run a PowerShell script!** This cookbook unlocks the
  revolutionary power of using a scripting language to... run scripts :smile:.
  It does this by doing something you've most likely already done on
  your workstation, but in case you haven't, or you're setting up a
  new workstation, it sets the PowerShell execution policy to
  `Unrestricted` so that you can run scripts without signing them.
* **Use the ssh client.** Because the `git` client distribution
  installed by this cookbook also contains an `ssh` client, you can
  use it simply by executing the `ssh` command from PowerShell or
  other shells on the system.
* **Get to your Documents directory fast**. This cookbook defines an
  alias `docs` that will change your current directory to your
  *Documents* directory, even if it's configured to a network
  location. Very useful since Windows developer workstations often
  contain more traditional "document" content. Consider this one a
  bonus feature.

### Advanced cookbook usage and notes

Advanced usage includes customizing the file `~/winbox-ps-profile.ps1`
used by this cookbook's PowerShell profile. Editing this file is an
easy way to update the PowerShell profile directly.

Here is additional behavior related to PowerShell profiles:

* The cookbook never alters an existing PowerShell profile.
* To use this cookbook's PowerShell profile if you have an existing
  profile, rename your PowerShell profile and run the `powershell_dev`
  recipe or any other recipe such as `default` that includes it.
* The PowerShell profile used by this cookbook actually uses the
  content in `~/winbox-ps-profile.ps1`, which is not updated if it
  already exists. To get profile changes from subsequent revisions of
  the cookbook, rename `~/winbox-ps-profile.ps1` and re-run the
  correct recipe.
* Note that because `~/winbox-ps-profile.ps1` is not updated by this
  cookbook if it exists, it's safe for you to edit its content to
  customize your profile.

### How to use Windows -- an aside

Efficient, sophisticated users of Windows follow these rules:

* **Always use PowerShell.** Never use `cmd.exe`, and no *cygwin* except for fun.
* **Use PowerShell cmdlets for everything** instead of GUI tools (e.g. `get-eventlog` instead of *EventViewer*)
* **Use the `man` alias** in PowerShell to get detailed help on commands.
* **Use `ConEmu` as your PowerShell terminal.**
* **Use [`psreadline`](https://github.com/lzybkr/PSReadLine#usage)** for `bash`-like key-bindings, history search
* **Use a real editor, not `notepad.exe`.** Emacs, VI(m), Atom, Visual Studio are real editors.
* **Use `chocolatey`** as your package manager to obtain software.
* **Use `psget`** to obtain PowerShell modules.

See subsequent sections for details on why this advice matters.

## Recipe inventory

### winbox::default
Use this recipe to get common tools required for development.

In addition to the default recipe, the following recipes with more
focused functionality may be used in your runlist.

### winbox::chocolatey_install
Installs the Chocolatey package manager. This recipe is an alternative
to the default recipe in the
[Chocolatey cookbook](https://github.com/chocolatey/chocolatey-cookbook),
which at the time of this cookbook's authoring had a number of blocking
issues that prevented it from installing Chocolatey reliably.

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

### Advanced recipes
The following recipes are not included by the default recipe -- you'll
need to explicitly add them to your run list to use them. They are not
part of the default set because they are applicable for significantly
less common use cases or they may have an unquantifiable impact to other
applications or configuration of the system.

#### winbox::debugger
Installs the Windows debuggers from the Windows SDK. The
`debugger_install_path` attribute allows customization of the
directory into which the debuggers are installed.

#### winbox::vscode_emacs
Install Emacs-like key bindings for the Visual Studio Code editor.

### Recipe customization

The following attributes can be used to customize the cookbook's
behavior:

#### `editor` attribute

The `editor` attribute determines the text editor to install via the
`editor` (and thus `default`) recipes. It's not mandatory to specify
its value explicitly since it has a default value, but it **must** be
set to a valid value if its overridden:

| `editor` value | Description                                           |
|----------------|-------------------------------------------------------|
| `:vscode`      | **Default**. Sets the editor to *Visual Studio Code*. |
| `:atom`        | Sets the editor to the Atom editor.                   |
| `:emacs`       | Sets the editor to Emacs.                             |
| `:vim`         | Sets the editor to Vim                                |

#### `debugger_install_path` attribute

The `debugger_install_path` attribute is a file system path into which
the debuggers should be installed.

## TODO

* Add unit tests
* Integration tests
* Change this cookbook to a resource-only cookbook

## Motivation for Winbox

The *Winbox* cookbook delivers a Windows workstation user experience optimized
for software developers:

* It's a way of demonstrating to users of
  both Windows and non-Windows platforms that there is indeed a presciptive
  toolset for development on Windows.
* It introduces users to the tools they need for a modern development
  experience on the Windows platform.

*Winbox* is necessary because the tools that are readily accessible to
developers in a default installation of Windows are tedious and
inefficient relics of Windows' single-tasking, non-networked, 16-bit heritage when
Windows was primarily used by non-technical office workers and home
users. During those early days of Windows prior to the move to the NT
kernel, technical users like developers were to be found using
various flavors of Unix, mainframe operating systems, and even Windows
cousin OS/2.

Windows has changed dramatically since those times, accelerating past
its peers in several areas of operating system engineering. However,
the tools used by developers around command-line and text interaction
with the system, as well as package management and acquisition of open
source software components have lagged significantly, in some cases
staying frozen in time along with the pre-NT kernel.

The PowerShell shell has been a notable exception to this stagnation,
but even here the otherwise excellent PowerShell which in many ways
surpasses peers like the well-regarded `bash` shell and its relatives
has been shackled by the terminal application used by humans to access
it. In the year 2015, this terminal is largely unchanged from the
terminal released with the original version of 32-bit Windows, Windows
NT 3.1 in *1992*.

### Closing gaps

The tools in *Winbox* fill in the omissions in Windows for developers,
and allow Windows users to have the same workflow as those using, say,
Linux, and thus to experience the gains in developer productivity associated
with such non-Windows systems.

Perhaps more importantly, *Winbox* can show Windows developers that
they need to uplevel their workflow in order to stay relevant in a
world that contains far more Linux and open-source-influenced tooling
and assumptions than the late 20th and very early 21st centuries.

## Bonus - How to Windows, extended version
The default tools in Windows are not only insufficient for developer productivity, but they actually encourage poor habits such as resorting to graphical tools rather than automatable command-line tools.

Fortunately, modern versions of Windows along with the features installed by this cookbook allow developers to be effective -- just follow the rules below:

* **Always use PowerShell, never use cmd.exe**. Given Microsoft's ongoing investment in PowerShell and its ecosystem and the associated lack of investment (essentially abandonment) in cmd.exe, it should not be necessary to state this. However, many users, either due to missing knowledge (e.g. "What's PowerShell?") or simply out of long-time cmd-habit continue to use cmd.exe. PowerShell is absolutely superior in terms of usability and capability to cmd.exe and is more than comparable with Unix shells like `bash`.
* **Do not use cygwin for work that targets Windows**. Cygwin is impressive in its ability to provide a Unix-like feel for Windows. However, the cost is that this Unix "emulation" makes Cygwin a poor choice for managing or otherwise interacting with platform specific features of Windows. For example, PowerShell allows native access of the Windows Registry via the command line. Cygwin ships with no such registry-related utilities. In general, many of the cmdlets supplied with PowerShell or that ship with hundreds of popular Windows applications and services have no equivalent on Cygwin. Cygwin is more than capable when it is used by Unix administrators who rarely interact with Windows and simply need a way to navigate the file system and launch applications and scripts or even generate local executables from source via Unix-y toolchains. But the best choice for producing software for Windows or managing a Windows system remains PowerShell.
* **Use ConEmu as your PowerShell terminal**. Simply launching PowerShell from a Windows Start Menu icon or using "Start / Run" to launch `powershell.exe` results in the execution of the barely usable default terminal for Windows console applications, the same one used to host cmd.exe. The terminal can't be resized without accessing a menu, uses block selection rather than wrapped selection, and does not support ANSI escape sequences for color and related formatting. ConEmu has sane defaults and supports the same color and selection capabilities as the terminals for Unix workstations. If you use this cookbook to configure a workstation, ConEmu is installed by default, and you can launch it from the Start Menu or by executing `conemu64.exe`.
* **Use chocolatey and psget to obtain software**. No system comes with the absolute perfect set of installed software components for each individual. While Windows has a wide range of software available, getting it usually involves an Internet search followed by navigation of a download process, and finally a manually launched installation process that may or may not require answering some questions. Contrast this to package managers like `apt` and `yum` on Linux, where software can be installed with a single command. In this usage, packages have unique but meaningful-to-humans names that can be easily guessed, memorized, or if needed searched via the command-line tools. Then a single command can use that name to perform the entire download and installation of the software. This is a much faster world, and one brought a lot closer to reality on Windows by `chocolatey`, for software in general, and also by `psget`, for PowerShell modules that can enhance your shell experience.
* **Get used to using `man` for help on PowerShell`**. The `man`(ual) command on Unix predates the ability to perform Internet searches for help using commands. However, the facility continues to be very useful as a fast and predictable way to get help. PowerShell's `man` command (actually an alias for `get-help`) provides just as much utility as the Unix `man`, with a common structure for help (including examples). If your question is really about how to use a command, use `man` first before you search the Internet. The command can also provide general topic help with the "about" topics, e.g. `man about_operators`. And its `-online` parameter even supports updating the help, bringing `man` into the present with Internet support.
* **Use a real editor, not `notepad.exe`**. It's not clear why `notepad.exe`, a very commonly used tool, has seen almost no improvement in functionality since it was originally introduced in Windows 1.0 in 1985. As the default text editing application for its operating system. `notepad.exe` is quite deficient compared to its counterpart in Unix, `vi`. While `vi` is relatively spare in terms of user experience, it operates capably on almost any text format, and can scale to very advanced usage with practice. Notepad fails simply when editing files that don't use the regrettable *CRLF* line endings -- an entire file of multiple lines will be rendered on one line! Also, even familiarity with Notepad's limited keyboard shortcuts is still a cumbersome and awkward editing experience. "Real" editors can handle multiple file formats, allow for fast editing of multiple files, and can provide affordances such as syntax highlighting and language awareness for a variety of languages and not just those used on a particular platform.
* **Skip the GUI tools, use PowerShell for all.** If you've used Windows for more than a few years, the most natural way to accomplish a task is usually to launch a GUI application. That's because the body of knowledge around Windows is dominated by the time before PowerShell was capable of handling such tasks (or even existed). While it may go against your experience, you need to **force** yourself to perform tasks such as browsing the Windows Event Log, viewing current processes, or installing software from the command line. Ultimately, you'll save yourself time simply from the faster interaction at the command line vs. finding and launching guis and switching context, and you'll end up automating common tasks. It will also force you to learn PowerShell and make you even faster. Think of it this way -- if you were using Unix, you'd have no choice but to use the CLI. PowerShell is sufficiently broad that there's no reason other than habit that you can't do the same on Windows.


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

