# Vibe Coding the Simulation

## First Prompt - creating the basis

Hi! can you write me a struct of a many body fermionic basis with every state represented by an integer, and each bit represents a population of a state with angular momentum ranging from m_min to m_max, with a fixed number of particles N, where the total angular momentum is a fixed number M?

## Creating the many body potential hamiltonian

using the Basis struct in basisCreation.jl and a single partical diagonal hamiltonian, write a function that generates the appropriate many body hamiltonian

## Creating the many body interaction hamiltonian

Awesome! can you now write a function that uses the FermionicBasis struct, the 2-particle interaction hamiltonian tensor and generates the many body interaction hamiltonian? Be mindful of the fermionic sign when exchanging particles and make sure you fill the hamiltonian in O(length(basis)), since this is a large sparse matrix. Use the fact that the 2-particle interaction is only non zero when m1+m2=m3+m4

## Testing the fermionic operators

looks really good! Now can you add another file where you test annihilate and create so that I can be sure they do what I think they should?

## Spectrum analysis and visualization

can you add a function that constructs the many body hamiltonian given the parameters mMin,mMax,N,interactionStrength,potentialStrength for every value of total angular momentum M, and plots the low lying spectrum on a united plot as a function of M?

## Setting up the project dependencies

Can you add a Project.toml file with all the packages needed for this project?

didn't you forget arpack?

## Improving the spectrum plot visualization

amazing! now help me make the plot a little nicer: make it a scatter plot instead of a line and make the markers into line shapes

Awesome! now make all the lines the same color, and make the plot size=(1000,1000), and enlarge the fonts even more

