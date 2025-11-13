using SparseArrays

# include("LLLInteractionAndConfinementHamiltonians.jl")
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

"""
    annihilate(state::UInt, m::Int, m_min::Int)

Annihilate a particle in orbital m. Returns (new_state, sign) where sign accounts
for fermionic anticommutation. Returns (0, 0) if orbital is unoccupied.
"""
function annihilate(state::UInt, m::Int, m_min::Int)
    bit_pos = m - m_min
    
    # Check if orbital is occupied
    if (state >> bit_pos) & 1 == 0
        return (UInt(0), 0)
    end
    
    # Count fermions to the right (lower bit positions) for sign
    mask = (UInt(1) << bit_pos) - 1
    sign = iseven(count_ones(state & mask)) ? 1 : -1
    
    # Remove particle
    new_state = state ⊻ (UInt(1) << bit_pos)
    
    return (new_state, sign)
end

"""
    create(state::UInt, m::Int, m_min::Int)

Create a particle in orbital m. Returns (new_state, sign) where sign accounts
for fermionic anticommutation. Returns (0, 0) if orbital is already occupied.
"""
function create(state::UInt, m::Int, m_min::Int)
    bit_pos = m - m_min
    
    # Check if orbital is already occupied
    if (state >> bit_pos) & 1 == 1
        return (UInt(0), 0)
    end
    
    # Count fermions to the right for sign
    mask = (UInt(1) << bit_pos) - 1
    sign = iseven(count_ones(state & mask)) ? 1 : -1
    
    # Add particle
    new_state = state ⊻ (UInt(1) << bit_pos)
    
    return (new_state, sign)
end

"""
    build_interaction_hamiltonian(basis::FermionicBasis, V_int::Array{Float64, 4})

Build the many-body interaction Hamiltonian from a two-particle interaction tensor.

# Arguments
- `basis::FermionicBasis`: The fermionic basis
- `V_int::Array{Float64, 4}`: Two-particle interaction tensor V[i,j,k,l] = ⟨m_i, m_j|V|m_k, m_l⟩
  where indices correspond to m_min:m_max

# Returns
- `SparseMatrixCSC`: The many-body interaction Hamiltonian matrix

# Notes
- Assumes V_int is only nonzero when m_i + m_j = m_k + m_l (angular momentum conservation)
- Properly accounts for fermionic anticommutation relations
- Efficient O(dim) scaling by only iterating over basis states once
"""
function build_interaction_hamiltonian(basis::FermionicBasis, V_int::Array{Float64, 4})
    n_orbitals = basis.m_max - basis.m_min + 1
    
    # Pre-allocate arrays for sparse matrix construction
    rows = Int[]
    cols = Int[]
    vals = Float64[]
    
    # Build a dictionary for fast state lookup
    state_to_index = Dict{UInt, Int}()
    for (idx, state) in enumerate(basis.states)
        state_to_index[state] = idx
    end
    
    # Iterate over all basis states
    for (idx_bra, state_bra) in enumerate(basis.states)
        
        # Find all pairs of occupied orbitals in bra state
        occupied = Int[]
        for m in basis.m_min:basis.m_max
            if get_occupation(state_bra, m, basis.m_min) == 1
                push!(occupied, m)
            end
        end
        
        # Iterate over all pairs of occupied orbitals (m1, m2)
        for i in 1:length(occupied)
            for j in (i+1):length(occupied)
                m1 = occupied[i]
                m2 = occupied[j]
                
                # Annihilate particles at m1 and m2
                state_temp, sign1 = annihilate(state_bra, m1, basis.m_min)
                if sign1 == 0
                    continue
                end
                state_temp, sign2 = annihilate(state_temp, m2, basis.m_min)
                if sign2 == 0
                    continue
                end
                
                total_sign_annihilate = sign1 * sign2
                
                # Now iterate over all possible pairs (m3, m4) to create
                for m3 in basis.m_min:basis.m_max
                    for m4 in basis.m_min:basis.m_max
                        if m4 <= m3  # Avoid double counting
                            continue
                        end
                        
                        # Check angular momentum conservation
                        if m1 + m2 != m3 + m4
                            continue
                        end
                        
                        # Get interaction matrix element
                        idx1 = m1 - basis.m_min + 1
                        idx2 = m2 - basis.m_min + 1
                        idx3 = m3 - basis.m_min + 1
                        idx4 = m4 - basis.m_min + 1
                        
                        V_elem = V_int[idx1, idx2, idx3, idx4]
                        if abs(V_elem) < 1e-14
                            continue
                        end
                        
                        # Create particles at m3 and m4
                        state_ket, sign3 = create(state_temp, m3, basis.m_min)
                        if sign3 == 0
                            continue
                        end
                        state_ket, sign4 = create(state_ket, m4, basis.m_min)
                        if sign4 == 0
                            continue
                        end
                        
                        total_sign = total_sign_annihilate * sign3 * sign4
                        
                        # Find index of ket state
                        if haskey(state_to_index, state_ket)
                            idx_ket = state_to_index[state_ket]
                            
                            # Add matrix element (factor of 1/2 to avoid double counting pairs)
                            matrix_element = 0.5 * total_sign * V_elem
                            push!(rows, idx_bra)
                            push!(cols, idx_ket)
                            push!(vals, matrix_element)
                        end
                    end
                end
            end
        end
    end
    
    # Build sparse matrix
    H_int = sparse(rows, cols, vals, basis.dim, basis.dim)
    
    # Symmetrize the matrix (H should be Hermitian)
    H_int = H_int + H_int'
    
    return H_int
end

