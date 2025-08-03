# Define the Java compiler
JC = javac

# Define the Java runtime
J = java

# Compiler flags
# -d <dir>: Specifies where to place generated class files.
# -sourcepath <path>: Specifies where to find input source files.
JFLAGS = -d build -sourcepath src

# The directory for compiled class files
BUILD_DIR = build

# The directory for source files
SRC_DIR = src

# The fully qualified name of your main class
MAIN_CLASS = com.craftinginterpreters.lox.Lox

# Find all .java files in the source directory
SOURCES = $(shell find $(SRC_DIR) -name "*.java")

# The default target, executed when you just run "make"
# This is an alias for the "run" target.
.PHONY: default
default: run

# Target to compile all Java source files
# Creates the build directory if it doesn't exist.
# Compiles all sources found into the build directory.
.PHONY: compile
compile:
	@echo "Compiling Java sources..."
	@mkdir -p $(BUILD_DIR)
	$(JC) $(JFLAGS) $(SOURCES)

# Target to run the main class
# It depends on "compile", so it will compile first if needed.
# The "-cp" or "-classpath" flag is the crucial part. We set it to our build directory.
# The "$$@" allows you to pass arguments from the command line to your Java program.
# For example: make run SCRIPT=my_script.lox
.PHONY: run
run: compile
	@echo "Running Lox..."
	$(J) -cp $(BUILD_DIR) $(MAIN_CLASS) $(SCRIPT)

# Target to clean up the project (remove compiled files)
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf $(BUILD_DIR)
