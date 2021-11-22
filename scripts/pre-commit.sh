echo "Running pre-commit hook"
./scripts/run-code-style-check.sh

# $? stores exit value of the last command
if [ $? -ne 0 ]; then
 echo "Code must be clean before commiting"
 exit 1
fi