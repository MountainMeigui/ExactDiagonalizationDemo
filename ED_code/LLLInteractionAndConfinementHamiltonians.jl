using LinearAlgebra
using SpecialFunctions

function confiningHamiltonian(mMin::Int64, mMax::Int64, potential_strength::Float64)
    m0 = (mMin + mMax) / 2
    # r0 = sqrt(2 * (m0 + 1)) * magneticLength
    x0 = sqrt(2 * (m0 + 1))

    numOrbitals = mMax - mMin + 1
    Hconf = zeros(Float64, numOrbitals)

    for m in mMin:mMax
        index = m - mMin + 1
        matrixElement = (2 * (m + 1) - x0^2) * (gamma_inc(m + 1, x0^2 / 2)[2] - gamma_inc(m + 1, x0^2 / 2)[1]) / gamma(m + 1)
        matrixElement = matrixElement + 4 * (x0^2 / 2)^(m + 1) / gamma(m + 1) * exp(-x0^2 / 2)
        matrixElement = matrixElement * potential_strength
        Hconf[index] = matrixElement
    end
    return Hconf
end

function interactionHamiltonian(mMin::Int64, mMax::Int64, interaction_strength::Float64)
    #This is a specific when only V_1 is non-zero interaction Hamiltonian for demonstration purposes.
    numOrbitals = mMax - mMin + 1
    Hint = zeros(Float64, numOrbitals, numOrbitals, numOrbitals, numOrbitals)
    # println("mMin: $mMin, mMax: $mMax, numOrbitals: $numOrbitals")
    for m1 in mMin:mMax
        for m2 in mMin:mMax
            for m3 in mMin:mMax
                for m4 in mMin:mMax
                    index1 = m1 - mMin + 1
                    index2 = m2 - mMin + 1
                    index3 = m3 - mMin + 1
                    index4 = m4 - mMin + 1

                    if m1 + m2 == m3 + m4
                        matrixElement = overlapWithCOMAndRelativeCoordinateStates(m1, m2, m1 + m2 - 1, 1) *
                                        overlapWithCOMAndRelativeCoordinateStates(m3, m4, m3 + m4 - 1, 1)
                        Hint[index1, index2, index3, index4] = matrixElement * interaction_strength
                    end
                end
            end
        end
    end
    return Hint
end

function overlapWithCOMAndRelativeCoordinateStates(m1::Int64, m2::Int64, M::Int64, mRel::Int64)
    if m1 + m2 != M + mRel
        return 0.0
    end
    
    overlap = 0.0

    for l in 0:mRel
        overlap = overlap +
                  (-1)^l * (binomial(m1, mRel - l) * binomial(m2, l) - binomial(m2, mRel - l) * binomial(m1, l))
    end

    # Compute normalization factor using BigInt to avoid integer overflow
    # Then convert back to Float64 for the final calculation
    norm_squared = Float64(factorial(big(mRel)) * factorial(big(M))) / 
                   Float64(big(2)^(m1 + m2 + 2) * factorial(big(m1)) * factorial(big(m2)))
    
    normalization = sqrt(norm_squared)
    overlap = overlap * (1 / 2) * normalization
    return overlap
end