using Test

include("ManyBodyHamiltonian.jl")

"""
Test suite for fermionic creation and annihilation operators
"""

@testset "Fermionic Operators Tests" begin
    
    @testset "Annihilation operator" begin
        # Test annihilating from an occupied state
        # State: |101⟩ (particles at m=0 and m=2, m_min=0)
        state = UInt(0b101)
        
        # Annihilate at m=0 (rightmost position)
        new_state, sign = annihilate(state, 0, 0)
        @test new_state == UInt(0b100)
        @test sign == 1  # No particles to the right
        
        # Annihilate at m=2 (leftmost occupied position)
        new_state, sign = annihilate(state, 2, 0)
        @test new_state == UInt(0b001)
        @test sign == -1  # One particle to the right at lower bit (at m=0)
        
        # Annihilate at m=1 (unoccupied)
        new_state, sign = annihilate(state, 1, 0)
        @test new_state == UInt(0)
        @test sign == 0  # Cannot annihilate from empty state
    end
    
    @testset "Creation operator" begin
        # State: |100⟩ (particle at m=2, m_min=0)
        state = UInt(0b100)
        
        # Create at m=0 (rightmost position)
        new_state, sign = create(state, 0, 0)
        @test new_state == UInt(0b101)
        @test sign == 1  # No particles to the right
        
        # Create at m=1
        new_state, sign = create(state, 1, 0)
        @test new_state == UInt(0b110)
        @test sign == 1  # One particle to the right (at m=2), but we count particles at LOWER bit positions, which is zero
        
        # Create at m=2 (already occupied)
        new_state, sign = create(state, 2, 0)
        @test new_state == UInt(0)
        @test sign == 0  # Cannot create in occupied state
    end
    
    @testset "Fermionic anticommutation" begin
        # Test that {c_i, c_j} = 0 (anticommutation of creation operators)
        # Start with |00⟩
        state = UInt(0b00)
        
        # Create at m=0 then m=1
        state1, sign1 = create(state, 0, 0)
        state1, sign2 = create(state1, 1, 0)
        result1 = sign1 * sign2
        
        # Create at m=1 then m=0
        state2, sign3 = create(state, 1, 0)
        state2, sign4 = create(state2, 0, 0)
        result2 = sign3 * sign4
        
        @test state1 == state2  # Same final state
        @test result1 == -result2  # Opposite signs (anticommutation)
    end
    
    @testset "Multiple operations" begin
        # State: |1010⟩ (particles at m=1 and m=3, m_min=0)
        state = UInt(0b1010)
        
        # Annihilate at m=1, then create at m=0
        state_temp, sign1 = annihilate(state, 1, 0)
        @test state_temp == UInt(0b1000)
        @test sign1 == 1  # One particle to the right
        
        final_state, sign2 = create(state_temp, 0, 0)
        @test final_state == UInt(0b1001)
        @test sign2 == 1  # No particles to the right
    end
    
    @testset "Sign accumulation example" begin
        # Demonstrate correct fermionic sign for c†₃ c†₂ c₁ c₀ |0101⟩
        # Initial state: particles at m=0 and m=2
        state = UInt(0b0101)
        
        # Annihilate c₀
        state, s1 = annihilate(state, 0, 0)
        @test s1 == 1
        @test state == UInt(0b0100)
        
        # Annihilate c₁ (should fail - unoccupied)
        state_fail, s2 = annihilate(state, 1, 0)
        @test s2 == 0
        
        # Annihilate c₂
        state, s3 = annihilate(UInt(0b0101), 2, 0)
        @test s3 == -1  # One particle to the right at lower bit (at m=0)
        @test state == UInt(0b0001)
        
        # Then annihilate c₀
        state, s4 = annihilate(state, 0, 0)
        @test s4 == 1
        @test state == UInt(0b0000)
        
        # Create c†₂
        state, s5 = create(state, 2, 0)
        @test s5 == 1
        @test state == UInt(0b0100)
        
        # Create c†₃
        state, s6 = create(state, 3, 0)
        @test s6 == -1  # Particle at bit 2 (m=2), mask=0b0111, gives 1 particle to the right
        @test state == UInt(0b1100)
        
        # Total sign should be s3 * s4 * s5 * s6 = (-1) * 1 * 1 * (-1) = 1
        @test s3 * s4 * s5 * s6 == 1
    end
    
    @testset "Non-zero m_min" begin
        # Test with m_min = 2
        # State represents m=2,3,4,5 with particle at m=3 and m=5
        # Bit representation: |1010⟩ where bit 0 is m=2, bit 1 is m=3, etc.
        state = UInt(0b1010)
        m_min = 2
        
        # Annihilate at m=3 (bit position 1)
        new_state, sign = annihilate(state, 3, m_min)
        @test new_state == UInt(0b1000)
        @test sign == 1
        
        # Create at m=4 (bit position 2)
        new_state, sign = create(state, 4, m_min)
        @test new_state == UInt(0b1110)
        @test sign == -1  # One particle at lower bit position (bit 1, m=3)
    end
end

println("\nRunning fermionic operator tests...")
println("=" ^ 50)
