# Papermill demo

This repository contains a demo of [Papermill](https://papermill.readthedocs.io) running on [NeSI](https://www.nesi.org.nz/).

The goal is to demonstrate how to use it to run non-interactively a series of notebooks on an HPC plateform.


## Installation

TODO clone the repo

Create a Conda environment:
```
module purge && module load Miniconda3/4.10.3
conda env create -p venv -f environment.yml
```

For reproducibility, save the version of installed packages in `environment.lock.txt`:
```
conda env export -p venv --no-builds | sed "/^name/d; /^prefix/d" > environment.lock.yml
```
Note this file can be used to create the environment instead of `environment.yml`.

Install a jupyter kernel for the notebooks:
```
module purge && module load JupyterLab
nesi-add-kernel -p ./venv papermill_demo
```


## Demo

TODO 2 notebooks available

Activate the virtual environment:
```
module purge && module load Miniconda3/4.10.3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate ./venv
```

TODO
```
mkdir results
```

TODO
```
papermill -k papermill_demo -p result_file results/dataset.npz \
    notebooks/preprocessing.ipynb results/preprocessing.ipynb
```

TODO
```
papermill -k papermill_demo \
    -p input_file results/dataset.npz \
    -f config/short_run.yaml \
    notebooks/model_fitting.ipynb \
    results/model_fitting_short.ipynb
```

TODO
```
sbatch slurm/fit_long_run.sl
```

TODO
```
squeue -u "$USER"
```

TODO snakemake
```
snakemake --profile slurm
```