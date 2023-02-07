set -e

rm -rf jupyter-notebooks
git clone https://github.com/moderneinc/jupyter-notebooks.git jupyter-notebooks
rm -rf jupyter-notebooks/.git

# If there is a directory called jupyter-notebooks then read all its contents 
# and make a ts file that exports an object where the keys are the directories
# and the values are a string array of files in the directory
if [ -d "jupyter-notebooks" ]; then
  echo "Reading jupyter-notebooks directory"
  touch moderne-jupyter-notebooks.ts
  echo "export const AVAILABLE_JUPYTER_NOTEBOOKS = {" > moderne-jupyter-notebooks.ts
  for dir in jupyter-notebooks/*; do
    if [ -d "$dir" ]; then
      echo "  \"${dir#jupyter-notebooks/}\": [" >> moderne-jupyter-notebooks.ts
      for file in $dir/*; do
        if [ -f "$file" ]; then
          echo "    \"${file#$dir/}\"," >> moderne-jupyter-notebooks.ts
        fi
      done
      echo "  ]," >> moderne-jupyter-notebooks.ts
    fi
  done
  echo "}" >> moderne-jupyter-notebooks.ts
fi

rm -rf jupyter

jupyter lite build \
  --contents jupyter-notebooks \
  --output-dir jupyter \
  --no-sourcemaps \
  --config jupyter-lite.json
