using Test

include("LLLInteractionAndConfinementHamiltonians.jl")

"""
Test suite for confining Hamiltonian and interaction Hamiltonian
"""

@testset "Confining Hamiltonian Tests" begin
    
    @testset "Positive confining potential energies" begin
        # Test various parameter ranges (mMin is always >= 1)
        test_cases = [
            (1, 6, 0.1, "Small range, weak potential"),
            (1, 10, 1.0, "Medium range, medium potential"),
            (2, 20, 0.5, "Large range, medium potential"),
            (5, 15, 2.0, "Offset range, strong potential")
        ]
        
        for (mMin, mMax, V_conf, description) in test_cases
            println("Testing: $description (m ∈ [$mMin, $mMax], V_conf=$V_conf)")
            
            h_conf = confiningHamiltonian(mMin, mMax, V_conf)
            
            # Check that all diagonal elements are positive
            @test all(h_conf .> 0) || 
                  error("Confining potential has negative values: $(minimum(h_conf)) for $description")
            
            println("  ✓ All energies positive. Range: [$(minimum(h_conf)), $(maximum(h_conf))]")
        end
    end
    
end

@testset "Interaction Hamiltonian Tests" begin
    
    @testset "Angular momentum conservation" begin
        mMin, mMax = 1, 6
        V_int_tensor = interactionHamiltonian(mMin, mMax, 1.0)
        
        # Check that V is only nonzero when m1 + m2 = m3 + m4
        for m1 in mMin:mMax
            for m2 in mMin:mMax
                for m3 in mMin:mMax
                    for m4 in mMin:mMax
                        idx1 = m1 - mMin + 1
                        idx2 = m2 - mMin + 1
                        idx3 = m3 - mMin + 1
                        idx4 = m4 - mMin + 1
                        
                        V_elem = V_int_tensor[idx1, idx2, idx3, idx4]
                        
                        if m1 + m2 != m3 + m4
                            @test abs(V_elem) < 1e-14
                        end
                    end
                end
            end
        end
        
        println("  ✓ Interaction conserves angular momentum")
    end

end

println("\nRunning Hamiltonian tests...")
println("=" ^ 50)
