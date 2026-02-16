**Topic:** The Philosophy and "Why" behind the System.
## The Vision
To move from managing individual computers to managing a Fleet. The hardware is treated as a "dumb terminal" (disposable), while the configuration is the "Source of Truth" (persistent).
## Key Architectural Decisions
1. Nix Flakes as the Foundation:
	- Why: To achieve Hermeticity (absolute reproducibility). By using a flake.lock file, we ensure that every machine in the fleet uses the exact same version of every package at the exact same time. It eliminates the "it works on my machine" problem.
2. Modular GitOps Approach:
	- Why: The configuration lives in a remote Git repository above the hardware. We don't "tweak" systems; we "re-align" them to the Git state.
3. Home Manager Integration:
	- Why: To decouple the "User Environment" (CLI tools, shell aliases, dotfiles) from the "System Environment" (drivers, kernel, networking). This allows the "vibe" of the terminal to be identical on Linux and macOS.
4. Targeting Mixed Hardware:
	- Why: The design must support Heterogeneous Architectures (Intel x86, Apple Silicon ARM, Raspberry Pi ARM) within a single Flake.