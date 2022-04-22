# Papermill demo

This repository contains a demo of [Papermill](https://papermill.readthedocs.io) running on [NeSI](https://www.nesi.org.nz/).

The goal is to demonstrate how to use it to run non-interactively a series of notebooks on an HPC plateform.


## Installation

From a terminal running on NeSI, clone this repository:
```
git clone https://github.com/nesi/papermill_demo
```

Create a Conda environment:
```
module purge && module load Miniconda3/4.10.3
conda env create -p venv -f environment.lock.yml
```

Install a jupyter kernel for the notebooks:
```
module purge && module load JupyterLab
nesi-add-kernel -p ./venv papermill_demo cuDNN/8.1.1.33-CUDA-11.2.0
```

*Note: The `environment.lock.yml` file contains the version of all installed packages for reproducibility.
It has been generated from a conda environment created using the `environment.yml` file and exported it as follows:*
```
conda env export -p venv --no-builds | sed "/^name/d; /^prefix/d" > environment.lock.yml
```


## Demo

This repository contains 3 notebooks:

- [preprocessing.ipynb](notebooks/preprocessing.ipynb) downloads the MNIST dataset and split it in train/test sets,
- [model_fitting.ipynb](notebooks/model_fitting.ipynb) fits a simple MLP model on the prepared MNIST dataset.
- [keras_model.ipynb](notebooks/keras_model.ipynb) fits a MLP model on the MNIST dataset using Keras and Keras Tuner.

The following example will illustrate how to run the first 2 notebooks non-interactively and with different parameters.

Activate the virtual environment:
```
module purge && module load Miniconda3/4.10.3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate ./venv
```

First, let's run the preprocessing notebook, saving the dataset in the `results` folder:
```
papermill -k papermill_demo -p result_file results/dataset.npz \
    notebooks/preprocessing.ipynb results/preprocessing.ipynb
```
The `-p result_file results/dataset.npz` option injects this parameter in the notebook.

Note that the `-k papermill_demo` option sets the jupyter kernel to run the notebook.

Next, we can run the model fitting model with a set of parameters injected from a [file](config/short_run.yaml), using the `-f` option:
```
papermill -k papermill_demo \
    -p input_file results/dataset.npz \
    -f config/short_run.yaml \
    notebooks/model_fitting.ipynb \
    results/model_fitting_short.ipynb
```

To run it on a larger node, we can use a [slurm script](slurm/fit_long_run.sl) to request the relevant resources:
```
sbatch slurm/fit_long_run.sl
```
and check if the job is running using `squeue`:
```
squeue -u "$USER"
```

Finally, let's combine it with [Snakemake](https://snakemake.readthedocs.io) to get a [workflow](Snakefile) using Slurm jobs and running multiple configurations:
```
snakemake --profile nesi
```
