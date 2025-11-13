"""
    FermionicBasis

A many-body fermionic basis where each state is represented by an integer.
Each bit represents the occupation (0 or 1) of a single-particle state with 
angular momentum m, ranging from m_min to m_max.

Fields:
- `N::Int`: Fixed number of particles
- `M::Int`: Fixed total angular momentum
- `m_min::Int`: Minimum angular momentum
- `m_max::Int`: Maximum angular momentum
- `states::Vector{UInt}`: Vector of basis states (each state is an integer)
- `dim::Int`: Dimension of the Hilbert space
"""
struct FermionicBasis
    N::Int          # Number of particles
    M::Int          # Total angular momentum
    m_min::Int      # Minimum angular momentum
    m_max::Int      # Maximum angular momentum
    states::Vector{UInt}  # Basis states
    dim::Int        # Dimension of the basis
    
    function FermionicBasis(N::Int, M::Int, m_min::Int, m_max::Int)
        states = generate_basis_states(N, M, m_min, m_max)
        new(N, M, m_min, m_max, states, length(states))
    end
end

"""
    generate_basis_states(N, M, m_min, m_max)

Generate all valid basis states with N particles, total angular momentum M,
and single-particle angular momenta ranging from m_min to m_max.
"""
function generate_basis_states(N::Int, M::Int, m_min::Int, m_max::Int)
    states = UInt[]
    n_orbitals = m_max - m_min + 1
    
    # Iterate through all possible configurations
    for config in 0:(2^n_orbitals - 1)
        # Check if this configuration has exactly N particles
        if count_ones(config) != N
            continue
        end
        
        # Calculate total angular momentum
        total_M = 0
        for i in 0:(n_orbitals - 1)
            if (config >> i) & 1 == 1
                m = m_min + i
                total_M += m
            end
        end
        
        # Check if total angular momentum matches
        if total_M == M
            push!(states, config)
        end
    end
    
    return states
end

"""
    get_occupation(state::UInt, m::Int, m_min::Int)

Get the occupation number (0 or 1) of angular momentum state m.
"""
function get_occupation(state::UInt, m::Int, m_min::Int)
    bit_index = m - m_min
    return (state >> bit_index) & 1
end

"""
    state_to_string(state::UInt, m_min::Int, m_max::Int)

Convert a state to a human-readable string showing occupations.
"""
function state_to_string(state::UInt, m_min::Int, m_max::Int)
    n_orbitals = m_max - m_min + 1
    occupations = [get_occupation(state, m_min + i, m_min) for i in 0:(n_orbitals - 1)]
    return "|" * join(occupations, "") * "⟩"
end

# Example usage:
# basis = FermionicBasis(3, 6, 0, 5)  # 3 particles, total M=6, m from 0 to 5
# println("Basis dimension: ", basis.dim)
# for (i, state) in enumerate(basis.states)
#     println("State $i: ", state_to_string(state, basis.m_min, basis.m_max))
# end
