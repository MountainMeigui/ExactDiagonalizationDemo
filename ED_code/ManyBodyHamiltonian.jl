using SparseArrays

include("LLLInteractionAndConfinementHamiltonians.jl")
include("basisCreation.jl")

"""
    build_diagonal_hamiltonian(basis::FermionicBasis, h_diagonal::Vector{Float64})

Build the many-body Hamiltonian matrix for a single-particle diagonal Hamiltonian.

# Arguments
- `basis::FermionicBasis`: The fermionic basis
- `h_diagonal::Vector{Float64}`: Single-particle diagonal Hamiltonian energies, 
  indexed by angular momentum m (from m_min to m_max)

# Returns
- `SparseMatrixCSC`: The many-body Hamiltonian matrix (diagonal)

# Example
```julia
basis = FermionicBasis(3, 6, 0, 5)
h_sp = [float(m) for m in basis.m_min:basis.m_max]  # Single-particle energies
H = build_diagonal_hamiltonian(basis, h_sp)
```
"""
function build_diagonal_hamiltonian(basis::FermionicBasis, h_diagonal::Vector{Float64})
    n_orbitals = basis.m_max - basis.m_min + 1
    
    # Check that h_diagonal has the right size
    if length(h_diagonal) != n_orbitals
        error("h_diagonal must have length $(n_orbitals), got $(length(h_diagonal))")
    end
    
    # Build diagonal matrix
    diagonal_elements = zeros(Float64, basis.dim)
    
    for (idx, state) in enumerate(basis.states)
        energy = 0.0
        # Sum over all occupied orbitals
        for i in 0:(n_orbitals - 1)
            if (state >> i) & 1 == 1  # If orbital i is occupied
                m = basis.m_min + i
                orbital_idx = m - basis.m_min + 1
                energy += h_diagonal[orbital_idx]
            end
        end
        diagonal_elements[idx] = energy
    end
    
    # Return as sparse diagonal matrix
    return spdiagm(0 => diagonal_elements)
end

