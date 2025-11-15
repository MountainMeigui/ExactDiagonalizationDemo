# 🚀 Your Journey to Becoming a Vibe Coder: A Setup Guide

Welcome to the world of computational physics! This guide will take you from zero to hero, setting up all the tools you need to write beautiful code, run simulations, and document your discoveries. Buckle up, some steps take time (looking at you, TeX), but trust me, it's worth it.

---

## 📦 Step 1: Install Git (Your Time Machine for Code)

**What is it?** Git is version control software that tracks changes to your code. Think of it as a time machine that lets you rewind mistakes, collaborate with others, and keep your work safe.

**How to install:**
- **Windows**: Download from [git-scm.com](https://git-scm.com/download/win) and run the installer. Accept the defaults—they're sensible.
- **Mac**: Open Terminal and type `git --version`. If it's not installed, macOS will prompt you to install Xcode Command Line Tools (which includes Git).
- **Linux**: Run `sudo apt-get install git` (Debian/Ubuntu) or `sudo yum install git` (Fedora/RHEL).

**Verify it worked:** Open a terminal/PowerShell and type:
```bash
git --version
```
You should see something like `git version 2.x.x`.

**Pro tip:** Set your identity right away:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## 💻 Step 2: Install VS Code (Your New Best Friend)

**What is it?** Visual Studio Code is a lightweight but powerful code editor with extensions for everything: Julia, LaTeX, Python, GitHub integration, you name it.

**How to install:**
1. Go to [code.visualstudio.com](https://code.visualstudio.com/)
2. Download the version for your OS
3. Install and launch it

**Why VS Code?** It's free, fast, extensible, and has incredible GitHub Copilot integration (which you'll want as a student - see Step 3).

---

## 🔬 Step 3: Install Julia (The Language of Speed and Elegance)

**What is it?** Julia is a high-performance programming language designed for scientific computing. It's as fast as C but as easy to write as Python. Perfect for exact diagonalization, quantum simulations, and matrix gymnastics.

**How to install:**
1. Go to [julialang.org/downloads](https://julialang.org/downloads/)
2. Download the installer for your OS (get the stable release, currently 1.10+)
3. Run the installer
4. **Windows users:** Make sure to check "Add Julia to PATH" during installation

**Verify it worked:** Open a terminal and type:
```bash
julia --version
```

**First steps in Julia:** Launch Julia by typing `julia` in your terminal. Try:
```julia
println("Hello, quantum world!")
2 + 2
```
Type `exit()` to leave the Julia REPL.

---

## 🎓 Step 4: Get GitHub Student Developer Pack (Free Stuff Alert!)

**What is it?** GitHub offers students free access to premium tools including GitHub Copilot, cloud credits, domain names, and more. It's like a cheat code for your academic career.

**How to apply:**
1. Go to [education.github.com/students](https://education.github.com/students)
2. Click "Sign up for Student Developer Pack"
3. You'll need:
   - A GitHub account (free to create at [github.com](https://github.com))
   - Proof you're a student (school email or upload a photo of your student ID)
4. Wait for approval (usually takes up to 72 hours)

**What you get:**
- **GitHub Copilot** (AI pair programmer, seriously life-changing)
- Free GitHub Pro
- Access to tons of developer tools and services

**Pro tip:** Once approved, install the GitHub Copilot extension in VS Code (we'll cover this in Step 6).

---

## 📝 Step 5: Install TeX Live (Patience Required)

**What is it?** TeX Live is a comprehensive LaTeX distribution for writing beautiful scientific documents, equations, and papers. This is how you'll document your research with professional-quality typesetting.

**Fair warning:** This installation takes a LONG time (30 minutes to 2+ hours depending on your internet and computer). Grab a coffee, tea, or take a nap.

**How to install:**

**Windows:**
1. Go to [tug.org/texlive/acquire-netinstall.html](https://tug.org/texlive/acquire-netinstall.html)
2. Download `install-tl-windows.exe`
3. Run it and select "Install" (full installation recommended)
4. Go do something else. Seriously. It's gonna be a while.

**Mac:**
1. Go to [tug.org/mactex](https://tug.org/mactex/)
2. Download MacTeX.pkg (~4GB)
3. Run the installer
4. Wait. And wait some more.

**Linux:**
```bash
sudo apt-get install texlive-full  # Debian/Ubuntu
sudo yum install texlive-scheme-full  # Fedora/RHEL
```

**Verify it worked:** After installation, open a terminal and type:
```bash
pdflatex --version
```

**Alternative (faster but less complete):** If you're impatient, try [MiKTeX](https://miktex.org/) which installs packages on-demand instead of everything upfront.

---

## 🧩 Step 6: Install VS Code Extensions (Supercharge Your Editor)

Extensions turn VS Code from a text editor into a full-fledged development environment. Here are the must-haves for this project:

### How to install extensions:
1. Open VS Code
2. Click the Extensions icon in the sidebar (or press `Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for the extension name
4. Click "Install"

### Essential Extensions:

#### **For Julia:**
- <img src="icons/julia.png" width="24" height="24"> **Julia** (julialang.language-julia)
  - Syntax highlighting, REPL integration, debugging, plotting support
  - This is THE Julia extension—install it first

#### **For LaTeX:**
- <img src="icons/latex-workshop.png" width="24" height="24"> **LaTeX Workshop** (James-Yu.latex-workshop)
  - Compile, preview, syntax highlighting, autocomplete for LaTeX
  - Auto-builds your PDFs on save
  - Essential for writing papers

#### **For Git/GitHub:**
- <img src="icons/copilot.png" width="24" height="24"> **GitHub Copilot** (GitHub.copilot)
  - AI-powered code suggestions (requires Student Developer Pack from Step 4)
  - This tool literally helped write this entire project
- <img src="icons/gitlens.png" width="24" height="24"> **GitLens** (eamodio.gitlens)
  - Supercharged Git integration—see who changed what, when, and why


### After installing:
1. Reload VS Code if prompted
2. For Julia: Open a `.jl` file and VS Code will ask if you want to install the Julia language server, say yes
3. For LaTeX: Create a `.tex` file and try building it (`Ctrl+Alt+B` or `Cmd+Alt+B`)

---

## 🎯 You're Ready!

Congratulations! You now have a complete scientific computing setup:
- ✅ Git for version control
- ✅ VS Code as your editor
- ✅ Julia for high-performance computing
- ✅ GitHub + Copilot for collaboration and AI assistance
- ✅ LaTeX for beautiful documentation
- ✅ Extensions to make it all work seamlessly

**Next steps:**
1. Clone this repository: `git clone https://github.com/mountainMeigui/ExactDiagonalizationDemo.git`
2. Open it in VS Code: `code ExactDiagonalizationDemo`
3. Check out `README.md` for how to run the simulations
4. Read `meta/vibe_coding_the_simulation.md` to see how this whole project came together

Now go forth and compute! 🚀✨




