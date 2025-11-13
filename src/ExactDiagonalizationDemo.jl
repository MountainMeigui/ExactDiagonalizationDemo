module ExactDiagonalizationDemo

# Include all the core functionality from ED_code
include("../ED_code/basisCreation.jl")
include("../ED_code/ManyBodyHamiltonian.jl")
include("../ED_code/LLLInteractionAndConfinementHamiltonians.jl")
include("../ED_code/spectrum_analysis.jl")

# Re-export key functions for convenience
export compute_spectrum_vs_M, save_spectrum_plot

end