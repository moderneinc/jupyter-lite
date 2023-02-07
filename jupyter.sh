set -e

rm -rf jupyter-notebooks
git clone https://github.com/moderneinc/jupyter-notebooks.git jupyter-notebooks
rm -rf jupyter-notebooks/.git

# If there is a directory called jupyter-notebooks then read all its contents 
# and make a ts file that exports an object where the keys are the directories
# and the values are a string array of files in the directory
if [ -d "jupyter-notebooks" ]; then
  echo "Reading jupyter-notebooks directory"
  touch constants/jupyter-notebooks.ts
  echo "export const AVAILABLE_JUPYTER_NOTEBOOKS = {" > constants/jupyter-notebooks.ts
  for dir in jupyter-notebooks/*; do
    if [ -d "$dir" ]; then
      echo "  \"${dir#jupyter-notebooks/}\": [" >> constants/jupyter-notebooks.ts
      for file in $dir/*; do
        if [ -f "$file" ]; then
          echo "    \"${file#$dir/}\"," >> constants/jupyter-notebooks.ts
        fi
      done
      echo "  ]," >> constants/jupyter-notebooks.ts
    fi
  done
  echo "}" >> constants/jupyter-notebooks.ts
fi

rm -rf public/jupyter

jupyter lite build \
  --contents jupyter-notebooks \
  --output-dir public/jupyter \
  --no-sourcemaps \
  --config jupyter-lite.json
