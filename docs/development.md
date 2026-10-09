# Development templates

Templates copy an independent development environment into your project. The catalog lives in [`templates/default.nix`](../templates/default.nix); each entry points to a directory whose contents are copied during initialization.

The copied flake belongs to the project and has no dependency on nixdots. Change its packages, environment variables, or inputs freely. Updating a template does not change existing projects, and editing a project does not change its template.

## Requirements

Install Nix with `nix-command` and `flakes` enabled; this NixOS configuration already enables them. Git is needed for the version-control examples. The first environment activation can download packages and requires network access. No NixOS rebuild is needed.

Check the selected template's `flake.nix` for its tools and supported systems.

## Choose a template

List the flake's outputs, including available templates and their descriptions:

```bash
nix flake show ~/nixdots
```

You can also inspect [`templates/default.nix`](../templates/default.nix) directly. In the commands below, replace `TEMPLATE_NAME` with a name from that catalog.

## Create a project

Start in an empty directory:

```bash
mkdir -p ~/projects/my-app
cd ~/projects/my-app
nix flake init -t ~/nixdots#TEMPLATE_NAME
git init
git add flake.nix .envrc .gitignore
nix flake lock
git add flake.lock
nix develop
```

The template files serve these purposes:

| File | Purpose |
| --- | --- |
| `flake.nix` | Defines the development tools, environment variables, and Nix inputs. |
| `.envrc` | Optionally activates the project's environment through direnv. |
| `.gitignore` | Keeps local caches and generated outputs out of Git. |

`nix flake lock` generates the project's own `flake.lock`, pinning its Nix inputs. `nix develop` can also generate it when missing. Nix reads files added to Git when the flake is inside a Git repository, so stage new Nix files before evaluating the environment. Review and commit the generated files along with your application.

Inside the shell, use the language's tools to initialize your application, install dependencies, run it, and execute its checks. The template supplies the development environment; application setup depends on your chosen language and framework.

If you are testing newly added templates in the nixdots checkout before staging them, use `nix flake init -t "path:$HOME/nixdots#TEMPLATE_NAME"`. Normal Git-backed references require the template files to have been added to Git.

For an existing project, commit or back up your work first. If `nix flake init` reports conflicting files, generate the template in an empty temporary directory and merge the desired contents into your project, especially `.gitignore` and any existing flake.

## Return to a project or share it

From the project directory, run `nix develop`. Exit the shell with `exit`. Someone cloning the project can use the same command with Nix installed; they do not need nixdots.

The Nix lock pins the inputs providing development tools. Your language's package manager manages application dependencies separately. Commit `flake.lock` and the applicable application manifests and lock files. Collaborators then install dependencies and run the application using the project's usual commands.

A development shell does not automatically define an application package for `nix build`. It also does not provide container isolation.

## Automatic activation with direnv

The included `.envrc` contains `use flake`, referring only to the project's own flake. This setup already enables direnv. With direnv shell integration available, review the file and run:

```bash
direnv allow
```

Entering the directory then loads the environment into your current shell; leaving it unloads the changes. Without direnv, use `nix develop` manually. The `.direnv` cache is ignored by Git.

## Customize and update

Edit `packages` in the copied `flake.nix` to add tools or native libraries. Set environment variables as attributes of `pkgs.mkShell`. Re-enter `nix develop` to load changes. You can also adapt `.envrc` and `.gitignore` to the project.

To update the project's Nix inputs:

```bash
nix flake update
nix develop
```

Run the project's checks, review `flake.lock`, and commit it. This update is independent of the nixdots lock and other projects.

## Add a template to nixdots

Create `templates/TEMPLATE_NAME/` with a standalone `flake.nix`, an `.envrc` containing `use flake`, and an appropriate `.gitignore`. Keep local caches, application build outputs, and generated lock files out of the template directory so each new project starts clean and generates its own lock.

Register the directory in `templates/default.nix`:

```nix
{
  # Keep existing entries here.
  TEMPLATE_NAME = {
    path = ./TEMPLATE_NAME;
    description = "Describe the development environment";
  };
}
```

Replace `TEMPLATE_NAME` with your chosen name. The root flake already imports this catalog, so adding an entry needs no root-flake or documentation changes. The catalog itself is not copied into projects; only the selected directory is copied. Test initialization in a temporary directory and run `nix develop` before committing the template.

See the official [flake initialization manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake-init), [flake and Git guidance](https://wiki.nixos.org/wiki/Flakes), and [nix-direnv documentation](https://github.com/nix-community/nix-direnv) for further details.
