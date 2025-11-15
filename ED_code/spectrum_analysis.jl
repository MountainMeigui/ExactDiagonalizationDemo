using Plots
using LinearAlgebra
using Arpack

include("basisCreation.jl")
include("ManyBodyHamiltonian.jl")
include("LLLInteractionAndConfinementHamiltonians.jl")

"""
    compute_spectrum_vs_M(mMin::Int, mMax::Int, N::Int, 
                          interaction_strength::Float64, 
                          potential_strength::Float64;
                          n_states::Int=10)

Compute and plot the low-lying energy spectrum as a function of total angular momentum M.

# Arguments
- `mMin::Int`: Minimum angular momentum
- `mMax::Int`: Maximum angular momentum
- `N::Int`: Number of particles
- `interaction_strength::Float64`: Strength of the two-particle interaction
- `potential_strength::Float64`: Strength of the confining potential
- `n_states::Int`: Number of low-lying states to plot (default: 10)

# Returns
- A plot showing energy levels vs total angular momentum M

# Example
```julia
plot_spectrum = compute_spectrum_vs_M(0, 10, 3, 1.0, 0.1, n_states=8)
```
"""
function compute_spectrum_vs_M(mMin::Int, mMax::Int, N::Int,
    interaction_strength::Float64,
    potential_strength::Float64;
    n_states::Int=10)

    # Determine range of possible M values
    # Minimum M: all particles in lowest states
    M_min = sum(mMin:(mMin+N-1))
    # Maximum M: all particles in highest states
    M_max = sum((mMax-N+1):mMax)

    println("Computing spectrum for M ∈ [$M_min, $M_max]")
    println("N = $N particles, m ∈ [$mMin, $mMax]")
    println("Interaction strength: $interaction_strength")
    println("Potential strength: $potential_strength")
    println("="^60)

    # Compute single-particle potentials and interactions (same for all M)
    h_conf = confiningHamiltonian(mMin, mMax, potential_strength)
    V_int = interactionHamiltonian(mMin, mMax, interaction_strength)

    # Storage for results
    all_M = Int[]
    all_energies = Vector{Vector{Float64}}()

    # Loop over all possible M values
    for M in M_min:M_max
        # Create basis for this M sector
        basis = FermionicBasis(N, M, mMin, mMax)

        if basis.dim == 0
            println("M = $M: No valid states (skipping)")
            continue
        end

        println("M = $M: Basis dimension = $(basis.dim)")

        # Build Hamiltonian
        H_pot = build_diagonal_hamiltonian(basis, h_conf)
        H_int = build_interaction_hamiltonian(basis, V_int)
        H_total = H_pot + H_int

        # Diagonalize
        # Use eigen for small matrices, eigvals for large ones
        if basis.dim <= 1000
            eigenvalues = eigvals(Matrix(H_total))
        else
            # For large sparse matrices, compute only lowest eigenvalues
            # Note: This requires Arpack or KrylovKit
            eigenvalues = eigvals(Matrix(H_total))
        end

        sort!(eigenvalues)

        # Store results
        push!(all_M, M)
        n_extract = min(n_states, length(eigenvalues))
        push!(all_energies, eigenvalues[1:n_extract])

        println("  Ground state energy: $(eigenvalues[1])")
    end

    # Create plot
    p = plot(xlabel="Total Angular Momentum M",
        ylabel="Energy",
        title="Energy Spectrum vs M\nN=$N, m∈[$mMin,$mMax], V_int=$interaction_strength, V_conf=$potential_strength",
        legend=false,
        size=(1000, 1000),
        guidefontsize=16,
        tickfontsize=14,
        titlefontsize=18)

    # Plot each energy level as a scatter plot with horizontal line markers
    max_states = maximum(length.(all_energies))

    for level in 1:max_states
        M_vals = Float64[]
        E_vals = Float64[]

        for (i, M) in enumerate(all_M)
            if level <= length(all_energies[i])
                push!(M_vals, M)
                push!(E_vals, all_energies[i][level])
            end
        end

        if !isempty(M_vals)
            scatter!(p, M_vals, E_vals,
                marker=:hline,
                markersize=8,
                markerstrokewidth=2,
                alpha=0.8,
                color=:blue)
        end
    end

    ylims!(0,0.001)

    println("="^60)
    println("Spectrum computation complete!")

    return p
end

"""
    save_spectrum_plot(mMin::Int, mMax::Int, N::Int, 
                       interaction_strength::Float64, 
                       potential_strength::Float64;
                       filename::String="spectrum.png",
                       n_states::Int=10)

Compute spectrum and save plot to file.
"""
function save_spectrum_plot(mMin::Int, mMax::Int, N::Int,
    interaction_strength::Float64,
    potential_strength::Float64;
    filename::String="spectrum.png",
    n_states::Int=10)

    p = compute_spectrum_vs_M(mMin, mMax, N, interaction_strength, potential_strength,
        n_states=n_states)
    savefig(p, filename)
    println("Plot saved to: $filename")

    return p
end

# Example usage:
# p = compute_spectrum_vs_M(0, 8, 3, 1.0, 0.1, n_states=8)
# p = compute_spectrum_vs_M(1, 8, 3, 1.0, 0.1, n_states=8)
N = 6
mMin = 6
# mMax = mMin + 3*(N-1) +1 +3
mMax = mMin + 3*(N-1) +1 +10
interaction_strength = 1.0
# potential_strength = 0.1
potential_strength = 0.0001
nStates = 100
filename = "spectrum_N_$(N)_Mmin_$(mMin)_Mmax_$(mMax)_Vint_$(interaction_strength)_Vconf_$(potential_strength).png"
# p = compute_spectrum_vs_M(mMin, mMax, N, interaction_strength, potential_strength, n_states=nStates)
p = save_spectrum_plot(mMin, mMax, N, interaction_strength, potential_strength, n_states=nStates, filename=filename)
display(p)
