# Exact Diagonalization Demo

This repository demonstrates how to use **GitHub Copilot** to write complicated scientific simulations with ease.

## Overview

This project implements an exact diagonalization (ED) simulation for studying many-body quantum systems, specifically focusing on fermionic systems in the Lowest Landau Level (LLL). The entire codebase was developed collaboratively with GitHub Copilot, showcasing how AI-assisted programming can accelerate complex scientific computing tasks.

## What This Demo Shows

- **Efficient basis construction** using bitwise representation of fermionic states
- **Many-body Hamiltonian building** with proper fermionic anticommutation relations
- **Sparse matrix techniques** for handling large Hilbert spaces
- **Numerical precision handling** in quantum mechanical calculations
- **Professional visualization** of energy spectra

## Project Structure

```
ExactDiagonalizationDemo/
├── ED_code/
│   ├── basisCreation.jl                          # Fermionic basis generation
│   ├── ManyBodyHamiltonian.jl                    # Many-body operators
│   ├── LLLInteractionAndConfinementHamiltonians.jl  # Single-particle Hamiltonians
│   ├── spectrum_analysis.jl                      # Spectrum computation and plotting
│   └── test_fermionic_operators.jl              # Unit tests
├── theory_and_text_files/
│   └── theoretical_introduction.tex             # LaTeX documentation
├── meta/
│   └── vibe_coding_the_simulation.md           # Development prompts log
└── Project.toml                                  # Julia dependencies
```

## Key Features

### 1. Fermionic Basis Construction
- Integer representation of many-body states using bitstrings
- Efficient generation of states with fixed particle number N and total angular momentum M
- Automatic angular momentum sector filtering

### 2. Many-Body Hamiltonians
- Diagonal single-particle potentials (confinement)
- Two-particle interactions with angular momentum conservation
- Proper handling of fermionic signs via creation/annihilation operators
- Sparse matrix storage for computational efficiency

### 3. Spectrum Analysis
- Automatic computation across all angular momentum sectors
- Professional visualization with customizable plots
- Low-lying energy level tracking

## Getting Started

### Prerequisites
- Julia 1.6 or later
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mountainMeigui/ExactDiagonalizationDemo.git
cd ExactDiagonalizationDemo
```

2. Activate and install dependencies:
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

### Running the Simulation

```julia
include("ED_code/spectrum_analysis.jl")

# Compute spectrum for 3 particles, m ∈ [0,8]
# with interaction strength 1.0 and confinement strength 0.1
p = compute_spectrum_vs_M(0, 8, 3, 1.0, 0.1, n_states=8)
display(p)

# Save the plot
save_spectrum_plot(6, 31, 6, 1.0, 10^-6, filename="spectrum.png", n_states=100)
```

## Development Process

This entire project was developed using GitHub Copilot as a coding assistant. The `meta/vibe_coding_the_simulation.md` file contains a complete log of prompts and interactions, demonstrating:

- How to break down complex physics problems into implementable code
- Iterative debugging and refinement with AI assistance
- Best practices for scientific computing in Julia
- Handling numerical precision issues in quantum simulations

## Physics Background

The simulation implements exact diagonalization for fermionic systems in the Lowest Landau Level (LLL), relevant for studying:
- Fractional Quantum Hall Effect (FQHE)
- Counter-propagating edge modes on an annulus geometry
- Quantum many-body physics in strong magnetic fields

## Dependencies

- **LinearAlgebra**: Matrix operations and eigenvalue computations
- **SparseArrays**: Efficient sparse matrix storage
- **SpecialFunctions**: Gamma functions for LLL matrix elements
- **Arpack**: Large-scale eigenvalue problems
- **Plots**: Visualization
- **Test**: Unit testing framework

## Contributing

This is a demonstration repository. Feel free to fork and extend it for your own research or educational purposes!

## License

MIT License - see LICENSE file for details

## Acknowledgments

This project showcases the power of AI-assisted scientific programming using GitHub Copilot. The entire codebase, from physics implementation to visualization, was developed through natural language prompts and iterative refinement.

---

**Note**: This repository serves as both a functional scientific simulation tool and a case study in AI-assisted programming for computational physics.
