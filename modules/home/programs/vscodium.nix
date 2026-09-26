{ pkgs, ... }:
let
  extensions = [
    pkgs.vscode-marketplace.pkief.material-icon-theme
    pkgs.vscode-marketplace.mkhl.direnv
    pkgs.vscode-marketplace.jnoortheen.nix-ide
  ];

  commonSettings = {
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.startupEditor" = "none";
    "workbench.layoutControl.enabled" = false;
    "workbench.editor.labelFormat" = "short";
    "window.titleBarStyle" = "native";
    "window.customTitleBarVisibility" = "never";
    "window.menuBarVisibility" = "hidden";
    "breadcrumbs.enabled" = false;
    "workbench.list.smoothScrolling" = true;

    "editor.lineHeight" = 1.8;
    "editor.fontLigatures" = true;
    "editor.padding.top" = 20;
    "editor.padding.bottom" = 20;
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.smoothScrolling" = true;
    "editor.scrollbar.horizontal" = "hidden";
    "editor.minimap.enabled" = false;
    "editor.stickyScroll.enabled" = false;
    "editor.renderLineHighlight" = "gutter";
    "editor.guides.bracketPairs" = true;
    "editor.rulers" = [ 120 ];

    "editor.tabSize" = 2;
    "editor.tabCompletion" = "on";
    "editor.wordWrap" = "wordWrapColumn";
    "editor.wordWrapColumn" = 100;
    "editor.linkedEditing" = true;
    "editor.inlineSuggest.enabled" = true;
    "editor.formatOnSave" = true;
    "editor.formatOnPaste" = false;
    "editor.codeActionsOnSave" = {
      "source.fixAll.eslint" = "explicit";
      "source.organizeImports" = "explicit";
    };

    "files.autoSave" = "afterDelay";
    "files.eol" = "\n";
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;
    "files.exclude" = {
      "**/.git" = true;
      "**/.DS_Store" = true;
    };
    "explorer.compactFolders" = false;
    "explorer.sortOrder" = "foldersNestsFiles";
    "workbench.tree.indent" = 15;
    "workbench.tree.renderIndentGuides" = "none";

    "explorer.fileNesting.enabled" = true;
    "explorer.fileNesting.patterns" = {
      "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lock, bun.lockb";
      "tsconfig.json" = "tsconfig.*.json";
      ".env" = ".env.*";
      "jest.config.*" = "jest.setup.*";
      "vitest.config.*" = "vitest.setup.*";
      "Dockerfile" = "Dockerfile.*, .dockerignore, docker-compose.*";
      ".gitignore" = ".gitattributes, .gitmodules";
    };

    "terminal.integrated.fontLigatures.enabled" = true;
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.stickyScroll.enabled" = false;

    "git.autofetch" = true;
    "diffEditor.ignoreTrimWhitespace" = true;

    "extensions.ignoreRecommendations" = true;
  };
in
{
  programs.vscodium = {
    enable = true;
    profiles = {
      default = {
        inherit extensions;
        userSettings = commonSettings;
      };
    };
  };
}
