<p align="center">
  <img src="https://github.com/user-attachments/assets/f57f81af-e82c-407c-9550-4a8f4341b43c" alt="Chapter Master - Adeptus Dominus Logo"/>
</p>

# Chapter Master - Adeptus Dominus

**Chapter Master** (aka CM) is a strategy/simulation game, written in **Game Maker Language**, originally designed and developed by Duke.\
This project aims to continue development on the game, fix any bugs, expand and add features.\
**Adeptus Dominus** is just how the team of collaborators calls themselves.

## Links

- [Discord Server](https://discord.gg/zAGpqHzsXQ)
   - Where most of the development talk, bug reporting, features suggestion and just general 40K talk takes place.
   - If you can code, design, draw and you love WH40K then you'll have a great time with us. :)
- [1d6Chan Wiki](https://1d6chan.miraheze.org/wiki/Chapter_Master_(game))
   - With some helpful pages that explain new systems added in the Adeptus Dominus version.

## Building and/or contributing

There are basically two ways of working with a GameMaker project: through Visual Studio Code or through GameMaker built-in IDE.

- Working through GameMaker IDE may prove to be a pure torture and as such generally is not reccomended if you plan on working with code.
- The prefered alternative is to use [Visual Studio Code](https://code.visualstudio.com/) with the [Stitch](https://github.com/bscotch/stitch) extension, that is aviable via the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=bscotch.bscotch-stitch-vscode). (huge thanks to guys who made it)

Nonetheless, some things will have to be done through GameMaker, such as: 
- Most of the sprite management.
- Debugging with breakpoints and variable checking is not supported by Stitch at the moment.

### The Visual Studio Code + Stitch way:

1. Get the Visual Studio Code installed, if not already.
   - (Optional) It's recommended to get the Insider version, as it's the most frequently updated one and gets all new features first.
   - (Optional) Get a hang of VSCode by reading some guides on the internet, installing some useful QoL extensions, configuring various settings, etc.
2. Get the Stitch extension installed.
   - (Optional) Watch [this guide video](https://youtu.be/N0wnHauUQjA?si=GPQ22a_LyZq3Y9LP) that covers basic features of **Stitch**, made by its creator.
   - (Optional) Edit various **Stitch** specific settings, to improve your QoL.
   - (Optional) It's recommended to disable "Run in Terminal" **Stitch** option. This will allow you to goto error lines that come up in the output window and custom color output lines. The explanation is in the "Stitch Runner Panel" section on [this page](https://marketplace.visualstudio.com/items?itemName=bscotch.bscotch-stitch-vscode).
3. Run the game by pressing F5 or finding the run button on the **Stitch** panel.
4. Play the game!
5. (Optional) Read the code, modify it, test, repeat.

### The GameMaker way:

1. Get the [GameMaker](https://gamemaker.io/en/) installed.
   - Only version up to 2023.11.1 are working with this project, as of now.
   - Here is a direct link for the GameMaker [v2023.11.1.129](https://gms.yoyogames.com/GameMaker-Installer-2023.11.1.129.exe), that most of collaborators use at the moment.
2. Download the project, by finding the green "<>Code" button and selecting "Download ZIP".
   - (Optional) If you want to contribute and know how to use Git/GitHub - clone the repository, otherwise check some basic Git guides first.
3. Find ChapterMaster.yyp in the cloned/downloaded project folder and open it with GameMaker.
4. In GameMaker, click the Run button or press F5 to build the project and start the game.
5. Play the game!
6. (Optional) Read the code, modify it, test, repeat.


### (Optional) Git Features:

If you are new to Git, then it's recommended to read the [Pro Git](https://git-scm.com/book/en/v2) book. You only need to read the first 3 chapters to comfortably work with Git, optionally chapter 6 to get more info on GitHub.

If you prefer a graphical user interface based approach to Git, instead of command line, then it's recommended to use one of the options bellow, both are free and popular:
-   [GitKraken](https://www.gitkraken.com/) + [Tutorials](https://www.gitkraken.com/learn/git/tutorials)
-   [SourceTree](https://www.sourcetreeapp.com/) + [Tutorials](https://confluence.atlassian.com/get-started-with-sourcetree)

## Exporting and creating packages

Creating packages (i.e. creating an .exe with the game) and exporting them is allowed for non-commercial use.

Everything else **must** be covered by paid GameMaker subscriptions:
- [GameMaker subscriptions comparison](https://gamemaker.io/en/get)
- [Setting up GameMaker export for Windows](https://help.yoyogames.com/hc/en-us/articles/235186048-Setting-Up-For-Windows)